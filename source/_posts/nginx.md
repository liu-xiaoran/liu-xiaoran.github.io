---
title: nginx使用try_files配置vue 4/119
date: 2022-2-16 17:21:45
---

## nginx使用try_files配置vue

组内的小伙伴最近独立开发的一个项目，前端使用VUE，路由模式使用history。
部署时发现无法访问，自己研究半天后，无法解决，向我寻求帮助，发现是他的nginx配置错误

其实 vue router 的文档里有部署方式，https://router.vuejs.org/zh/guide/essentials/history-mode.html#%E6%9C%8D%E5%8A%A1%E5%99%A8%E9%85%8D%E7%BD%AE%E7%A4%BA%E4%BE%8B
服务器配置示例：
location / {
  try_files $uri $uri/ /index.html;
}


随手写篇文章记录一下，nginx的location下的配置中
root，alias，try_files 区别，未来有时间可以写一篇nginx的深入文章，包含负载均衡、双机热备、缓存等高级功能。

root:
location /test/ {
    root /var/www/image
}
若按照上述配置的话，访问/test目录里面的文件时, nginx会自动去/var/www/image/test去找。

alias:
location /test/ {
 alias /var/www/image/
}
若按照上述配置的话，访问/img目录里面的文件时, nginx会自动去/var/www/image目录找文件, 也就是不会把后缀带上，常用来配置静态文件。

try_files:
location /test/ {
  try_files $uri $uri/ /index.html;
}
try_files 会到硬盘里尝试找这个文件, 找不到，就会 fall back 到 try_files 的最后一个选项index.html,将请求转发返回index.html上，然后html里的vue router再去跟去后缀路由对应的页面。

至此，完成history的转发。
