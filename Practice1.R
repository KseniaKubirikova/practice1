#Вариант 11: Требуется собрать данные ТОП-100 фильмов по версии Кинопоиска за 2018 год

# Загрузка пакетов

library('rvest')     # работа с DOM сайта
library('dplyr')     # инструменты трансформирования данных


#загрузка URL

url <- 'https://www.kinopoisk.ru/top/navigator/m_act[year]/2018/m_act[num_vote]/100/m_act[rating]/1%3A/m_act[gross]/%3A800/m_act[gross_type]/domestic/order/budget/perpage/100/#results'

# чтение HTML страницы
webpage <- read_html(url)


# отбор названий фильмов по селектору
title_data <- html_nodes(webpage,'div.name a') %>% html_text
head(title_data)

#информация по фильмам
info <- html_nodes(webpage, 'div.name span') %>% html_text
head(info)

#названия фильма на английском
eng <- gsub('\\s\\(.*','',info)
head(eng)

#режиссер
director <- html_nodes(webpage, 'span i') %>% html_text()
director <- gsub('реж. ', '',director)
head(director)

#продолжительность фильмов
time <- gsub('.*\\)\\s', '',info)
head(time)
time <- as.numeric(gsub('\\sмин.', '',time))
head(time)

#бюджет фильма
cost <- html_nodes(webpage, '.gray3') %>% html_text()
head(cost)
cost <- gsub('\\s', '',cost)
cost <- gsub('[$]','', cost)
head(cost)

#оценка IMDb
imdb <- html_nodes(webpage,'div.imdb') %>% html_text
head(imdb)
imdb <- gsub('IMDb: ','',imdb)
imdb <- gsub('\\s\\d*','',imdb)
imdb <- as.numeric(imdb) #final version for this
head(imdb)

#количество оценивших IMDb
Imdb_num <- html_nodes(webpage,'div.imdb') %>% html_text 
head(Imdb_num)
Imdb_num <- gsub('IMDb: \\d.\\d{2}','',Imdb_num)
Imdb_num <- gsub('\\s', '', Imdb_num)
Imdb_num <- as.numeric(Imdb_num)
head(Imdb_num)
str(Imdb_num)

#оценки фильма Кинопоиск
kino_mark <- html_nodes(webpage, '.numVote') %>% html_text()
head(kino_mark)
str(kino_mark)
#числовое выражение оценки Кинопоиск
mark <- gsub('\\s\\(.*\\)','',kino_mark)
mark <- as.numeric(mark)
head(mark)
#количество оценивших Кинопоиск
per_mark <- gsub('\\d.\\d*\\s\\(', '',kino_mark)
per_mark <- gsub('\\)','',per_mark)
per_mark <- gsub('\\s','', per_mark)
per_mark <- as.numeric(per_mark)
head(per_mark)

# совмещаем данные в один фрейм
DF.movies <- data.frame('Title'=title_data,
                        'English title'=eng,
                        'Director'=director,
                        'Runtime'=time,
                        'Cost'=cost,
                        'Kinopoisk mark'=mark,
                        'Marks from kinopoisk'=per_mark,
                        'IMDb mark'=imdb,
                        'Marks from IMDb'=Imdb_num)
dim(DF.movies)
head(DF.movies)

#записать файл csv
write.csv(DF.movies, file = "../top100_Kinopoisk_2018.csv", row.names = F)
# сделать запись в лог
write(paste('Файл "top100_Kinopoisk_2018.csv" записан', Sys.time()), 
      file = './data/download.log', append = T)

