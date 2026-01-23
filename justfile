typstc cmd file fmt="pdf":
  typst {{ cmd }} --root=. --font-path=. {{ file }} {{ replace(file, ".typ", "." + fmt) }}

doc: (typstc "watch" "docs/docs.typ")

test T: (typstc "watch" "tests/"+T+"/test.typ")

scrybe:
  scrybe -R README.md typst.toml docs/docs.typ --version="$(cat .version)"

scrybe-publish:
  scrybe -R release --publish --version="$(cat .version)"

bump ver:
  echo {{ ver }} > .version

publish:
  mkdir -p release
  rm -rf release/*
  cp -r src release/
  cp README.md LICENSE typst.toml release/
  rsync -rhP tests --include='*/' --include='gallery/*/ref/*.png' --exclude='*' release/

upstream:
  cat .version > /tmp/meander-version
  cd $(cat .packages) && \
    git checkout meander && \
    git fetch upstream && \
    git reset --hard upstream/main
  cp -r release $(cat .packages)/packages/preview/meander/$(cat .version)
  cd $(cat .packages) && \
    git add . && \
    git commit -m "meander:$(cat /tmp/meander-version)" && \
    git push --force


