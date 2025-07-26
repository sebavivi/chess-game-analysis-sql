



/* Jaki procent gier wygrywają białe? Ile z nich konczy się remisem? */
/* What percentage of games do white win? How many of them end in a draw? */

select 
	round(
		 (select 
		 	count(winner) 
		 from chess_games c2 
		 where c2.winner = 'white'
		 )	
		 /count(c.winner) *100, 2
		 )								as White_Winner_Percentage
	,round(
		 (select 
		 	count(winner) 
		 from chess_games c2 
		 where c2.winner = 'draw'
		 )	
		 /count(c.winner) *100, 2
		 )								as Draw_Percentage
from chess_games c 


/* Który pierwszy ruch był najczęściej stosowany w grach, w których wygrywały czarne?
  A w przypadku zwycięstw białych? */
/* Which first move was most commonly used in games won by black?
  And in games won by white? */

/* Black First Moves */

select 
	c.winner
	,SUBSTRING(c.moves, 1, 2)			as First_Moves 
	,count(SUBSTRING(c.moves, 1, 2))	as Number_of_Moves
from chess_games c 
where c.winner = 'Black'
group by 2
order by 3 desc


/* White First Moves */

select 
	c.winner
	,SUBSTRING(c.moves, 1, 2)			as First_Moves 
	,count(SUBSTRING(c.moves, 1, 2))	as Number_of_Moves
from chess_games c 
where c.winner = 'White'
group by 2
order by 3 desc


/* Jaki procent gier wygrywa gracz z wyższym rankingiem? Czy zależy to od koloru figur? */ 
/* What percentage of games does the player with the higher ranking win? 
 Does it depend on the color of the pieces? */

SELECT 
	round(
		   		(sum((c.winner = 'White' and c.white_rating > c.black_rating) or
		  			 (c.winner = 'Black' and c.black_rating > c.white_rating))
		  		/count(*)
		  		)*100, 2
		 )									as Winners_with_higher_rating
from chess_games c 


SELECT 
	c.winner
	,round(
		   		(sum((c.winner = 'White' and c.white_rating > c.black_rating) or
		  			 (c.winner = 'Black' and c.black_rating > c.white_rating))
		  		/count(*)
		  		)*100, 2
		  )									as Winners_with_higher_rating_percentage_group_color
from chess_games c 
where c.winner = 'White' or c.winner = 'Black'
group by c.winner


/* Który użytkownik wygrał najwięcej partii? 
 W jakich procentach tych gier ten użytkownik miał wyższy ranking? */


select 
	winner_id
	,count(*)	as wins
	,round((sum(Nr_higher_rating) / count(*))*100, 1)	as higher_rating_perc
	,sum(Nr_higher_rating)	high_rating_nr
from (
	 select
	 	case
	 		when c.winner = 'White' then c.white_id 
	 		when c.winner = 'Black'	then c.black_id
	 		else NULL 
	 	end	as winner_id
	 	,CASE 
	 		when c.winner = 'White' and c.white_rating > c.black_rating then 1
	 		when c.winner = 'White' and c.white_rating < c.black_rating then 0
	 		when c.winner = 'Black' and c.black_rating > c.white_rating then 1
	 		when c.winner = 'Black' and c.black_rating < c.white_rating then 0
	 	END	as Nr_higher_rating
	 from chess_games c 
	 )	as sub 
where sub.winner_id is not null 
group by sub.winner_id
order by wins desc





select 
	winner_id
	,count(*)	as wins
from (
	 select
	 	case
	 		when c.winner = 'White' then c.white_id 
	 		when c.winner = 'Black'	then c.black_id
	 		else NULL 
	 	end	as winner_id
	 from chess_games c 
	 )	as sub 
where sub.winner_id is not null 
group by sub.winner_id
order by wins desc












