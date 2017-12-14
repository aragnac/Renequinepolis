create DATABASE link cctocb CONNECT TO cb IDENTIFIED BY oracle USING 'ORCL';
select * from movie@cctocb ORDER BY id;