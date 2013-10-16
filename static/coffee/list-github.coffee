url = "https://api.github.com/users/emnh/repos"

a = (html, href) -> $("<a/>", { html: html, href: href })

li = (x) -> $("<li/>", { html: x })

ul = (list) ->
  d = $("<ul/>")
  li.appendTo(d) for li in list
  d

show = (data) ->
  repos = data
  link = (repo) -> a(repo.full_name, repo.html_url)
  repos = ul(li(link(repo)) for repo in repos)
  console.log(repos.html())
  repos.appendTo('body')

$.getJSON(url, show)