DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS message;
DROP TABLE IF EXISTS forgotlink;
DROP TABLE IF EXISTS activationlink;
DROP TABLE IF EXISTS credentials;

CREATE TABLE user (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  salt TEXT NOT NULL,
  email Text not Null
);

CREATE TABLE forgotlink (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  userid INTEGER NOT NULL,
  challenge TEXT not Null,
  created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  validuntil TIMESTAMP NOT NULL DEFAULT (DATETIME(CURRENT_TIMESTAMP , '+1 days')),
  state TEXT NOT NULL,
  FOREIGN KEY (userid) REFERENCES user (id)
);

CREATE TABLE activationlink (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  challenge TEXT not Null,
  created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  validuntil TIMESTAMP NOT NULL DEFAULT (DATETIME(CURRENT_TIMESTAMP , '+1 days')),
  state TEXT NOT NULL,
  username TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  salt TEXT NOT NULL,
  email Text not Null
);

CREATE TABLE message (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  from_id INTEGER NOT NULL,
  to_id INTEGER NOT NULL,
  created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  subject TEXT NOT NULL,
  body TEXT NOT NULL,
  FOREIGN KEY (from_id) REFERENCES user (id),
  FOREIGN KEY (to_id) REFERENCES user (id)  
);

CREATE TABLE credentials(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name   TEXT NOT NULL,
  user TEXT NOT NULL,
  password TEXT NOT NULL
);

INSERT INTO credentials (name,user,password) VALUES ('EMAIL_APP','demoflaskapp@outlook.com', '123456qwertASDF');
INSERT INTO user(username,password,salt,email) VALUES ('Admin','165f5399b55aa0b9703e5619651df392ce39e43905a906e58ee2bbe99af6af4b','pbkdf2:sha256:260000$i0o4buhUYxY42p4i$','charlapp_corporation@outlook.com');
