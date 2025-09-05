#! /usr/bin/env bash

list() {
  case "$1" in
    (test)
      echo "List of available tests:"
      ls tests
      ;;
    (examples)
      echo "List of examples:"
      ls examples
      ;;
    (*)
      echo "Unknown category '$1'"
      exit 1
      ;;
  esac
}

typstc() {
  typst "$1" --root=. "$2" "$3"
}

test() {
  case "$1:$2" in
    (:|all:run|:run) tt run;;
    (*:run|*:) tt run "$1";;
    (all:update) tt update;;
    (*:update) tt update "$1";;
    (*:open) touch x.pdf; evince x.pdf &;;
    (*:watch) typstc watch tests/$1/test.typ x.pdf;;
    (*) echo "Unsupported test command '$@'"
        exit 1
        ;;
  esac
}

example() {
  case "$2" in
    (open)
      touch examples/$1/main.pdf
      evince examples/$1/main.pdf &
      ;;
    (watch)
      typstc watch examples/$1/main.typ examples/$1/main.pdf
      ;;
    (img)
      typstc compile examples/$1/main.typ examples/$1/main.svg
      ;;
    ('')
      typstc compile examples/$1/main.typ examples/$1/main.pdf
      ;;
  esac
}

doc() {
  case "$1" in
    (open)
      touch docs/main.pdf
      evince docs/main.pdf &
      ;;
    (watch)
      typstc watch docs/main.typ docs/main.pdf
      ;;
    ('')
      typstc compile docs/main.typ docs/main.pdf
      ;;
  esac
}

"$@"
