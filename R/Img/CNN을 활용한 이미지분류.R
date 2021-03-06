# <라이브러리 불러오기>-----
library(RCurl)
library(XML)
library(dplyr)
library(httr)
library(rvest)
library(imager)


# <워킹디렉토리 설정>-----
setwd("C:/Users/Administrator/DSS/R/Img/DataSet")


# <URL주소 설정>-----
keyword = "bikini"
URL_g = paste0("https://www.google.co.uk/search?q=", keyword, "&newwindow=1&tbs=isz:ex,iszw:200,iszh:200,itp:photo&tbm=isch")
URL_i = paste0("https://www.instagram.com/explore/tags/", keyword, "/")
URL_f = paste0("https://kr.fotolia.com/search?k=bikini&filters%5Bcontent_type%3Aphoto%5D=1&filters%5Bhas_releases%5D=true&search-submit=%EA%B2%80%EC%83%89+&offset=0")
modify_url(URL_f, query = list("search?k"=keyword))


# <유저 에이전트 설정>-----
ua = user_agent("Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36")


# <브라우저 열기>-----
BROWSE(URL_g) # google
BROWSE(URL_i) # instagram


# <페이지 파싱-1>-----
attrs = GET(vikini, config = ua)%>%
        read_html()%>%
        html_nodes("img")%>%
        html_attr("data-src")%>%
        na.omit()


# <페이지 파싱-2-google>-----
bikini =  readLines("bikini.txt")
workout = readLines("workout-muscle.txt")
sex = readLines("sex.txt")

attr_manual = read_html(workout)%>%
  html_nodes("img")%>%
  html_attr("src")%>%
  grep("^[http]", x = ., value = T)


# <페이지 파싱-3-instagram>-----
bikini = readLines("bikini-1.txt")
bikini = readLines("bikini-2.txt")
bikini = readLines("bikini-3.txt")
attr_manual = regmatches(bikini, regexpr("(http).+?(\\.jpg)", bikini))

# <페이지 파싱-4-fotolia>-----
bikini = read_html(URL_f)%>%
         html_nodes("img")%>%
         regmatches(regexpr("(http).+?(\\.jpg)", .))
bikini


# <이미지 다운로드-1>-----
for(i in 1:length(attrs))
{
  print(i)
  download.file(a[i], sprintf("a_image_%02d.jpg", i), mode = "wb")
}


# <이미지 다운로드-2>-----
setwd("C:/Users/Administrator/DSS/R/Img/DataSet/bikini")
for(i in 1:length(attr_manual))
{
  print(i)
  download.file(attr_manual[i], sprintf("a_img_01_%.3d.jpg", 511+i), mode = "wb")
}

setwd("C:/Users/Administrator/DSS/R/Img/DataSet/workout")
for(i in 1:length(attr_manual))
{
  print(i)
  download.file(attr_manual[i], sprintf("a_img_02_%.3d.jpg", i), mode = "wb")
}

# <이미지 다운로드-3>-----
fotolia=c()
setwd("C:/Users/Administrator/DSS/R/Img/DataSet/fotolia")

for(i in 1:247)
{
  sprintf("page_%d", i)%>%
    print()
  page = (i*100)-100
  fotolia = modify_url(URL_f, query = list("search?k"=keyword, 
                                           offset=page))%>%
            GET(config=ua)%>%
            read_html(URL_f)%>%
            html_nodes("img")%>%
            regmatches(regexpr("(http).+?(\\.jpg)", .))
  
  for(j in 1:length(fotolia))
  {
    download.file(fotolia[j], sprintf("a_image_%03d_%06d.jpg", i, j), mode = "wb", quiet = T)
    sprintf("photo_%d", j)%>%
      print()
  }
}
#setInternet2(use=FALSE)

setwd("C:/Users/Administrator/DSS/R/Img/DataSet/sex")
for(i in 1:length(attr_manual))
{
  print(i)
  download.file(attr_manual[i], sprintf("img_11_%.3d.jpg", i), mode = "wb")
}

