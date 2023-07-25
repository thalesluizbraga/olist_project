## 1 - Business Problem

Gamers Club (aka GC) is a game platform that allows users to play games online using a freemium business model. Users can play for free, but in order to gain badges, skills, and benefits in the games, they need to subscribe. The CEO of GC has asked me, as a data analyst, to provide more visibility into the subscriptions to establish a foundation for future decisions and address customer churn.

To deliver quick results to the board, I selected data from September 2021 to February 2022 for the game Counter Strike as a test to prototype an initial scalable solution. For the analysis, there is a data warehouse containing tables that include data about player IDs, lobby IDs, and game stats, which are relevant for understanding the behavior of gamers who hold GC subscriptions.

The schema of tables and their relations can be seen in the image below:

![image](https://github.com/thaleras/gc_project/assets/79552263/aa7fe90b-aa53-4d09-a31a-2b10b0c6546b)

tb_lobby_stats_player: Contains data about game stats such as the map where the match was played, number of deaths, number of rounds played, and lobby ID.
tb_players: Contains data about players such as date of registration, date of birth, country, and player ID.
tb_players_medalha: Contains data about medals earned in the game such as date of creation, date of expiration, and medal ID.
tb_medalha: Contains data about each existing medal in the game, including description, type, and medal ID.

The access to the database is https://drive.google.com/file/d/1bdGq8UTDEpwNY2r_QJyX9wkuUQdnL7LN/view?usp=sharing


## 2 - Premises

The analysis considered data from September 2021 to February 2022.
The assumed business model is free-to-play (F2P).
The selected game for this analysis is Counter Strike.
The solution aims to create an Analytical Base Table (ABT) with the necessary features to gain insights into subscription behavior among Counter Strike users. Additionally, an ETL process will be developed to automate the functionality of the ABT and make it scalable. The table will record data from a 30-day window to provide an understanding of CS gamers' subscription behavior in the last 30 days.

## 3 - Solution Strategy

The solution involves:
Developing the ABT named tb_book_players, which will contain features such as player stats, lobby data, and medal data.
Developing an ETL process in Python, utilizing libraries like SQLAlchemy, tqdm, and datetime, to populate the SQL table.

## 4 - Final Product

The final product is a table loaded in the data warehouse, containing features that can be used for churn analysis, along with the ETL process behind it.

## 5 - Conclusion

The project successfully achieved its goal, as the ABT was created with features that provide a comprehensive understanding of CS gamers behavior.

## 6 - Next Steps

The next steps for the solution include developing machine learning (ML) models to predict future subscriptions and expanding the ABT and ML solutions to other products offered by the company.
