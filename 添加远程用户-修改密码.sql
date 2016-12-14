SET PASSWORD FOR 'root'@'localhost' = PASSWORD('newpass');


flush privileges;
grant all privileges on *.* to 'myuser'@'%' identified by 'mypassword' with grant option;