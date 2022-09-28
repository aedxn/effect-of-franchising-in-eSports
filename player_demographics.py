from mwrogue.esports_client import EsportsClient

site = EsportsClient("lol")

#extracting players birthdate
p_bday_1 = site.cargo_client.query(tables='Players', fields= 'ID, Birthdate, IsRetired, Residency')

#saving output into a text file
with open("player_bday_raw_1.txt", "w", encoding="utf-8") as external_file:
    print(p_bday_1, file=external_file)
    external_file.close()

