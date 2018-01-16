function Creature(name) {
    this.name = name;
    this.speak = function() {
	return "Hi, my name is " + this.name;};
    this.greet =function(){
	return "Howdy";};
};
var Cow = function (name){
    Creature.apply(this, arguments);
    this.speak = function(name){
	return "Moo, My name is " + this.name;};
};

var Dog = function (name){
    Creature.apply(this, arguments);
    this.speak = function(name){
	return "bark, My name is " + this.name;};
};
console.log( "The prototype is: ", Creature.prototype ); 
var a = new Creature("Leslie");
var b = new Cow("Alex");
var c = new Dog("Tim");
console.log( "Here's an object: ", a );

console.log(a.speak());
console.log(a.greet());
console.log(b.speak());
console.log(b.greet());
console.log(c.speak());
console.log(c.greet());
