Last login: Tue Dec 13 16:17:58 on ttys000
149-160-147-253:~ shengyuchen$ ssh chen435@silo.cs.indiana.edu
chen435@silo.cs.indiana.edu's password: 
Last login: Tue Dec 13 16:20:35 2016 from 156-56-154-6.dhcp-bl.indiana.edu


*******************************************************************
**   Indiana University School of Informatics and Computing      **
**             ** For Authorized Use Only **                     **
*******************************************************************
**  For general SoIC computing information, please see:          **
**      http://help.soic.indiana.edu/                            **
**                                                               **
**  To submit a problem report or question, please see:          **
**      http://help.soic.indiana.edu/request                     **
*******************************************************************


-bash: warning: setlocale: LC_CTYPE: cannot change locale (UTF-8): No such file or directory
ls
-bash: PATH: command not found
[chen435@silo ~]$ ls
C291         Music      a290-workspace            grails-2.3.4.zip
C343chen435  Pictures   apache-tomcat-7.0.35      graina2-master
CS-Fall2016  Public     apache-tomcat-7.0.35.tar  graina2-master.zip
Desktop      README     bin                       public
Documents    Templates  c335-submissions
Downloads    Videos     chen435-B351
HW4          a290-js    grails-2.3.4
[chen435@silo ~]$ cd a290-js
[chen435@silo a290-js]$ ls
apache  httpd-2.2.2  pra.txt  stageTwo  week1  week2
[chen435@silo a290-js]$ cd week1
[chen435@silo week1]$ ls
one.js
[chen435@silo week1]$ emacs two.js
[chen435@silo week1]$ node two.js 
The prototype is:  Creature {}
Here's an object:  Creature { name: 'Kathy', speak: [Function], greet: [Function] }
Hi, my name is Kathy
Howdy
[chen435@silo week1]$ ^C
[chen435@silo week1]$ emacs two.js
[chen435@silo week1]$ node two.js
The prototype is:  Creature {}
Here's an object:  Creature { name: 'Kathy', speak: [Function], greet: [Function] }
Hi, my name is Kathy
Howdy
Moo, My name is Alex
[chen435@silo week1]$ emacs two.js

File Edit Options Buffers Tools Javascript Help                                 
    this.speak = function(name){
        return "Moo, My name is " + this.name;};
};
var dog = function(name){
    Creature.apply(this, arguments);
    this.speak = function(name){
        return "Hi, My name is " + this.name;};
};

console.log( "The prototype is: ", Creature.prototype );

var a = new Creature("Kathy");

console.log( "Here's an object: ", a );

console.log( a.speak() );
console.log( a.greet() );

var b = new Cow("Alex");
console.log( b.speak() );

