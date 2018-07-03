Web scrape 23 separate pages one per state for all whole food store addresses

The code below is limited to 4 States(AL,AZ,AR and CA] urls[0:3] Page 0,1,2 and 3

see
https://tinyurl.com/yahkqdbz
https://stackoverflow.com/questions/51124551/get-list-of-whole-foods-stores-using-rvest

Alistaire profile
https://stackoverflow.com/users/4497050/alistaire


INPUT
=====

Number of pages = 23

This is the Wisconsin Page

              _        ___           _        _____               _
             \ \      / / |__   ___ | | ___  |  ___|__   ___   __| |___
              \ \ /\ / /| '_ \ / _ \| |/ _ \ | |_ / _ \ / _ \ / _` / __|
               \ V  V / | | | | (_) | |  __/ |  _| (_) | (_) | (_| \__ \
                \_/\_/  |_| |_|\___/|_|\___| |_|  \___/ \___/ \__,_|___/


                                  BUNCH OF IMAGES


Milwaukee                         Wauwatosa                             Madison
2305 N. Prospect Ave              11100 W. Burleigh Street              3313 University Ave
Milwaukee, WI 53211               Wauwatosa, WI 53222                   Madison, WI 53705
United States                     United States                         United States
Phone:                            Phone:                                Phone:
414.223.1500                      414-808-3600                          608.233.9566



There are 23 pages one for each state where Whole Foods has a store.
Allistaire take advantage of the numeric suffix for each page.

https://www.wholefoodsmarket.com/stores/list/state?page=0  Alabama
https://www.wholefoodsmarket.com/stores/list/state?page=1  California
...
https://www.wholefoodsmarket.com/stores/list/state?page=22 Wisconsin


EXAMPLE OUTPUT
--------------

 WORK.WANTWPS total obs=42

  TITLE    ADDRESS                            PHONE          HOURS

  Tempe    5120 S. Rural Rd Tempe, AZ 85282   205-730-2680   7:00am - 10:00pm Seven days a week
  Oracle   7133 N Oracle Rd Tucson, AZ 85704  256.801.3741   8:00am - 9:00pm seven days a week
 .......


PROCESS
=======

%utl_submit_wps64('
options set=R_HOME "C:/Program Files/R/R-3.3.2";
libname wrk  sas7bdat "%sysfunc(pathname(work))";
proc r;
submit;
source("C:/Program Files/R/R-3.3.2/etc/Rprofile.site", echo=T);
library(purrr);
library(rvest);
urls <- paste0("https://www.wholefoodsmarket.com/stores/list/state?page=", 0:22);
pages <- map(urls[0:2], function(url){
    Sys.sleep(10);
    read_html(url);
});
stores <- pages %>%
map_dfr(function(page){
page %>%
html_nodes(".views-row") %>%
map(html_nodes, ".field-content") %>%
keep(~length(.x) == 7) %>%
map_dfr(~list(title = html_text(.x[[2]]),
address = html_nodes(.x[[3]], "div") %>%
map(html_text) %>%
paste(collapse = "\n"),
phone = html_text(.x[[4]]),
hours = html_text(.x[[5]])))
});
stores;
endsubmit;
import r=stores data=wrk.wantwps;
run;quit;
');


OUTPUT
======

 WORK.WANTWPS total obs=42

  TITLE    ADDRESS                            PHONE          HOURS

  Tempe    5120 S. Rural Rd Tempe, AZ 85282   205-730-2680   7:00am - 10:00pm Seven days a week
  Oracle   7133 N Oracle Rd Tucson, AZ 85704  256.801.3741   8:00am - 9:00pm seven days a week
 .......

  Middle Observation(21 ) of WORK.WANTWPS - Total Obs 42

   -- CHARACTER --  TYPE     SAMPLE VALUE

  TITLE             C19      Haight Street
  ADDRESS           C104     690 Stanyan Stre
  PHONE             C14      (415) 876-6740
  HOURS             C86      8:00 AM - 10:00
  TOTOBS            C16      42

*                _               _       _
 _ __ ___   __ _| | _____     __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \   / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/  | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|   \__,_|\__,_|\__\__,_|

;

* Only need the stem of the url and the number of pages

Number of pages = 23

https://www.wholefoodsmarket.com/stores/list/state?page=# (where #=0 to 22)

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;


%utl_submit_wps64('
options set=R_HOME "C:/Program Files/R/R-3.3.2";
libname wrk  sas7bdat "%sysfunc(pathname(work))";
proc r;
submit;
source("C:/Program Files/R/R-3.3.2/etc/Rprofile.site", echo=T);
library(purrr);
library(rvest);
urls <- paste0("https://www.wholefoodsmarket.com/stores/list/state?page=", 0:22);
pages <- map(urls[0:2], function(url){
    Sys.sleep(10);
    read_html(url);
});
stores <- pages %>%
map_dfr(function(page){
page %>%
html_nodes(".views-row") %>%
map(html_nodes, ".field-content") %>%
keep(~length(.x) == 7) %>%
map_dfr(~list(title = html_text(.x[[2]]),
address = html_nodes(.x[[3]], "div") %>%
map(html_text) %>%
paste(collapse = "\n"),
phone = html_text(.x[[4]]),
hours = html_text(.x[[5]])))
});
stores;
endsubmit;
import r=stores data=wrk.wantwps;
run;quit;
');



