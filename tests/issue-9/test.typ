#import "/src/lib.typ" as meander

#let my-img-1 = box(width: 7cm, height: 7cm, fill: orange)
#let my-img-2 = box(width: 5cm, height: 3cm, fill: blue)
#let my-img-3 = box(width: 8cm, height: 4cm, fill: green)
#let my-img-4 = box(width: 5cm, height: 5cm, fill: red)
#let my-img-5 = box(width: 4cm, height: 3cm, fill: yellow)

#let chinese_text_1 = [
我每天的生活很有规律，也很简单。早上七点整，我会准时起床，先喝一杯温水，然后去洗漱。洗漱完后，我会在阳台做十分钟的简单运动，比如伸懒腰、慢走，让身体慢慢清醒过来。

之后我会做早餐，通常是煮鸡蛋、热牛奶和几片面包，偶尔也会煮一碗小米粥。早餐虽然简单，但营养很均衡，能让我有足够的精力开始一天的工作。吃完早餐，我会整理好背包，八点半准时出门去公司。

上班的路不算远，我通常步行过去，大概需要二十分钟。路上会经过一个小小的社区公园，每天都能看到很多老人在晨练，有的打太极，有的跳广场舞，还有的带着小狗散步。有时候我会放慢脚步，看看公园里的花草，感受一下清晨的新鲜空气，这让我觉得心情很舒畅。
到了公司，我会先打开电脑，整理当天要做的工作，然后开始认真处理每一件事。我的工作不算特别忙，但需要细心和耐心，所以我总是尽量把每一个细节都做好。中午十二点是午休时间，我会和同事一起去公司附近的餐厅吃午饭。

我们常点的菜都是很普通的家常菜，比如西红柿炒鸡蛋、青椒土豆丝、清蒸鱼，这些菜味道清淡，也很健康。吃饭的时候，我们会聊一些轻松的话题，比如周末去哪里玩、最近看了什么好看的电影。这样的聊天能让我们放松心情，也能增进彼此的感情。

午休时间有一个小时，吃完饭后我会在公司的休息区坐一会儿，有时候会看几页书，有时候会闭目养神，为下午的工作养足精神。下午六点，我准时下班回家，回家后先换一身舒服的衣服，坐在沙发上休息十分钟，看看手机上的新闻或者和朋友聊几句。

休息完后，我会去厨房准备晚饭，晚饭通常比早餐和午餐丰富一点，会做一两个自己喜欢的菜，再煮一碗汤。吃完饭收拾好厨房，我会去楼下的小区里散步。小区里的环境很好，有很多树木和草坪，晚上还有不少人在散步、遛狗或者带着孩子玩耍，热闹又温馨。

周末的时候，我通常不会待在家里，而是和朋友一起去城市里的大公园。那里空气清新，景色很美，我们会沿着湖边散步，有时候还能看到有人在钓鱼、划船。走累了就找一片草地坐下，拿出提前准备好的零食和水果，一边吃一边聊天，聊工作、聊未来的计划，偶尔也会吐槽生活里的小烦恼。

这样的时光总是过得很快，每次都觉得很开心、很放松。我很喜欢这样简单而充实的生活，虽然没有太多惊天动地的事情，但每一天都过得很安稳、很有意义。我喜欢清晨的阳光，喜欢上班路上的宁静，喜欢和同事相处的热闹，也喜欢周末和朋友共度的快乐时光。生活就像一杯温水，平淡却温暖，只要用心感受，就能发现其中的美好。
]

#let seg_ch = (con) => {
  for p in con.children {
    if (p.has("text")) {
      for c in p.text {
        [#c]
      }
    } else {
      [#p]
    }
  }
}

#meander.reflow(overflow: true, {
  import meander: *

  placed(top + left, my-img-1)
  placed(top + right, my-img-2)
  placed(horizon + right, my-img-3)
  placed(bottom + left, my-img-4)
  placed(bottom + left, dx: 32%, my-img-5)

  container()
  content[
    #set par(justify: true, first-line-indent: 2em)
    #chinese_text_1
  ]
})

#pagebreak()

#meander.reflow(overflow: true, {
  import meander: *

  placed(top + left, my-img-1)
  placed(top + right, my-img-2)
  placed(horizon + right, my-img-3)
  placed(bottom + left, my-img-4)
  placed(bottom + left, dx: 32%, my-img-5)

  container()
  content[
    #set par(justify: true, first-line-indent: 2em)
    #seg_ch(chinese_text_1)
  ]
})
