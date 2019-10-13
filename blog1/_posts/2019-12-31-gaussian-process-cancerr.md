---
layout: main_structure
title: "Project 1"
description: Lorem ipsum 
description_image: 2019-12-31-gaussian-process-cancer.png
date: 2019-10-08 00:15:23 +0200
read_time: 3
categories: jekyll update
---

You’ll find this post in your `_posts` directory. Go ahead and edit it and re-build the site to see your changes. You can rebuild the site in many different ways, but the most common way is to run `jekyll serve`, which launches a web server and auto-regenerates your site when a file is updated.

Jekyll requires blog post files to be named according to the following format:

`YEAR-MONTH-DAY-title.MARKUP`

Where `YEAR` is a four-digit number, `MONTH` and `DAY` are both two-digit numbers, and `MARKUP` is the file extension representing the format used in the file. After that, include the necessary front matter. Take a look at the source for this post to get an idea about how it works.

Jekyll also offers powerful support for code snippets:

{% highlight ruby %}
def print_hi(name)
  puts "Hi, #{name}"
end
print_hi('Tom')
#=> prints 'Hi, Tom' to STDOUT.
{% endhighlight %}

Check out the [Jekyll docs][jekyll-docs] for more info on how to get the most out of Jekyll. File all bugs/feature requests at [Jekyll’s GitHub repo][jekyll-gh]. If you have questions, you can ask them on [Jekyll Talk][jekyll-talk].

[jekyll-docs]: https://jekyllrb.com/docs/home
[jekyll-gh]:   https://github.com/jekyll/jekyll
[jekyll-talk]: https://talk.jekyllrb.com/


<div class="col-lg-6 card mb-3 card-all-projects">

  <div class="row no-gutters card-all-projects-content">

    <div class="col-md-4" style="background-image: url();">
    </div>

    <div class="col-md-8">
      <div class="card-body">
        <h5 class="card-title"></h5>
        <p class="card-text">{{ post.description }}</p>
        <p class="card-text"><small class="text-muted"><i class="far fa-clock"></i> <b>Read time:</b> {{ post.read_time }} mins</small></p>
      </div>

    </div>

  </div>

</div>



<div class="card col-sm-6 col-xl-4">
  <img class="card-img-top" src="..." alt="Card image cap">
  <div class="card-body">
    <h5 class="card-title">Card title</h5>
    <p class="card-text">Quick sample text to create the card title and make up the body of the card's content.</p>
    <a href="#" class="btn btn-primary">Go somewhere</a>
  </div>
</div>
