from mwrogue.esports_client import EsportsClient

site = EsportsClient("lol")

#extracting players birthdate
p_bday_1 = site.cargo_client.query(tables='Players', fields= 'ID, Birthdate, IsRetired, Residency')

#saving output into a text file
with open("player_bday_raw_1.txt", "w", encoding="utf-8") as external_file:
    print(p_bday_1, file=external_file)
    external_file.close()

# The downloaded file will be in an unstructured non-tabular format. To fix this I did the following
# outside of python:
#
# 1. I created a .bat file by:
# cd "C:\Users\Francois\Desktop\TRABAJO UB\Aedan\"
#
# powershell -Command "(player_bday_raw_1.txt)
# -replace 'OrderedDict', \"`r`n\"|SC player_day_raw_C.txt"
#
# I then used Stata to create a dataset with the following code:
# global files " "C:\Users\aedan\OneDrive\Uni\Masters\Barcelona\Thesis\Gaming\Esports\Data\1_Step\player_bday_C_1.txt" "
#
#
#
# foreach F in $files {
#
#
#
# clear
#
# import delimited `F'
#
# rename v2 ID
#
# rename v4 Birthdate
#
# rename v6 IsRetired
#
# rename v8 Residency
#
# rename v10 Birthdate_precision
#
# drop v1 v3 v5 v7 v9 v11
#
#
#
# global Variables " "ID" "Birthdate" "IsRetired" "Residency" "Birthdate_precision" "
#
#
#
# foreach s in $Variables {
#
# replace `s' = subinstr(`s',"'","",10)
#
# replace `s' = subinstr(`s',"[","",10)
#
# replace `s' = subinstr(`s',"]","",10)
#
# replace `s' = subinstr(`s',"(","",10)
#
# replace `s' = subinstr(`s',")","",10)
#
# }
#
#
#
# replace Birthdate = subinstr(Birthdate," 00:00:00","",1)
#
#
#
# gen Date = date(Birthdate,"YMD")
#
# gen day = day(Date)
#
# gen month = month(Date)
#
# gen year = year(Date)
#
#
#
# *save the file F here
#
#
#
# }
#
# *dropping observations of player who dont play in the top leagues
# rename ID Player
# replace Residency = trim(Residency)
# replace Player = trim(Player)
#
# mark keep if Residency == "North America" | Residency == "China" | Residency == "Europe" | Residency == "Korea"
# drop if keep == 0
#
# *deleting duplicates
# {
# duplicates list
# drop if _n == 116
# replace Player = "Funny" if Date == 14899 & Residency == "Korea"
# replace Player = "Jiangqiao" if Date == 13891 & Residency == "China"
# drop if _n == 142
# drop if _n == 378
# drop if _n == 380
# drop if Player == "Calix"
# drop if Player == "Captain" & Residency == "Korea"
# drop if Player == "Carrot"
# drop if Player == "Cat" & Residency == "North America"
# drop if Player == " Cherry"
# drop if Player == "Cookie"
# drop if Player == "Corn" & Residency == "Korea"
# drop if Player == "Crow" & Residency == "Europe"
# drop if Player == "Crown" & Residency == "Europe"
# drop if Player == "Cube" & Residency == " Korea"
# drop if Player == "Denis"
# drop if Player == "Diamond" & Residency == "Europe"
# drop if Player == "Dragon"
# drop if Player == "Duck"
# drop if Player == "Duke" & Residency == "Europe"
# drop if Player == "Dusk" & Residency == "Korea"
# drop if Player == "Emperor" & Residency == "Europe"
# drop if Player == "Fawn"
# drop if Player == "Fear"
# drop if Player == "Flash"
# drop if Player == "Fox" & Date == 15115
# drop if Player == "Franky"
# drop if Player == "Frozen" & Residency == "Europe"
# drop if Player == "Ghost"
# drop if Player == "Hachi"
# drop if Player == "Hades"
# drop if Player == "Helios" & Residency == "China"
# drop if Player == "Hiro"
# drop if Player == "Hoon" & Date == 9892
# drop if Player == "Hope" & Residency == "Korea"
# drop if Player == "Hybrid" & Date == 14670
# drop if Player == "Inferno"
# drop if Player == "Just"
# drop if Player == "Ken"
# drop if Player == "Lapis"
# drop if Player == "Lazy"
# drop if Player == "Legacy"
# drop if Player == "Leon"
# drop if Player == "Light" & Residency != "China"
# drop if Player == "Lion"
# drop if Player == "Lunar"
# drop if Player == "Lynx"
# drop if Player == "Mark" & Residency == "Europe"
# drop if Player == "Medic"
# drop if Player == "Melon" & Residency == "Europe"
# drop if Player == "Mental"
# drop if Player == "Mikkel"
# drop if Player == "Min"
# drop if Player == "Mint" & Residency == "Korea"
# drop if Player == "Moon" & Residency == "Europe"
# drop if Player == "Neo" & Residency == "North American"
# drop if Player == "Night"
# drop if Player == "Nino"
# drop if Player == "Nova" & Residency == "North American"
# drop if Player == "NoWay"
# drop if Player == "Paradox"
# drop if Player == "Pat"
# drop if Player == "Peng" & Residency == "Europe"
# drop if Player == "Practice"
# drop if Player == "Prime"
# drop if Player == "Prove" & Residency == "Europe"
# drop if Player == "QiuQiu" & Date == 12832
# drop if Player == "Rain" & Residency == "Europe"
# drop if Player == "Raven"
# drop if Player == "Raz"
# drop if Player == "Reach"
# drop if Player == "Reven" & Residency == "Europe"
# drop if Player == "Riku"
# drop if Player == "Rose"
# drop if Player == "Savage"
# drop if Player == "Save" & Date == 13775
# drop if Player == "Shadow"
# drop if Player == "Shark"
# drop if Player == "Shine"
# drop if Player == "Sky" & Residency != "Korea"
# drop if Player == "Smash"
# drop if Player == "Snail"
# drop if Player == "Sneaky" & Residency == "Europe"
# drop if Player == "Snow" & Residency != "China"
# drop if Player == "Solo" & Residency == "Korea"
# drop if Player == "Soul" & Residency == "China"
# drop if Player == "Space" & Residency == "Europe"
# drop if Player == "Stardust"
# drop if Player == "Steve" & Date == 12063
# drop if Player == "Sweet" & Date != 12975
# drop if Player == "Thanatos"
# drop if Player == "Tiger"
# drop if Player == "Valkyrie"
# drop if Player == "Viper" & Residency == "China"
# drop if Player == "Way"
# drop if Player == "Winner"
# drop if Player == "Winnie"
# drop if Player == "Wolf" & Residency != "Korea"
# drop if Player == "Woong"
# drop if Player == "Wudan"
# drop if Player == "bambi"
# }
