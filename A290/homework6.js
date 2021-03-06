function parse( input ) {
  var result = input.match( /^\s*\(\s*(\d+)\s*(.)\s*(\d+)\s*\)\s*$/ );  
  if (result == null) {
    var result = input.match( /^\s*\(\s*(\d+)\s*(.)\s*(\(.+\))\s*\)\s*$/ ); 
    if (result == null) {
      var result = input.match( /^\s*\((.+\))\s*(.)\s*(\d+)\s*\)\s*$/ );  
      if (result == null) {
        var result = input.match( /^\s*\(\s*(\(.+\))\s*(.)\s*(\(.+)\)\s*$/  ); 
        if (result == null) {
          return ""; 
        } else {
          return "( " + result[2] + " " + parse(result[1]) + " " + parse(result[3]) + " )" ;     
        }
      } else {
        return "( " + result[2] + " " + parse(result[1]) + " " + result[3] + " )" ;     
      }           
    } else {
      return "( " + result[2] + " " + result[1] + " " + parse(result[3]) + " )" ; 
    }  
  } else {
    return "( " + result[2] + " " + result[1] + " " + result[3] + " )" ; 
  } 
}

console.log( parse( " ( 1 + ( 3 + 4 ) ) " ) ); // ( + 1 ( + 3 4 ) ) 
console.log( parse ( " ( 12 + 19 ) " ) ); // ( + 12 19 )
console.log( parse ( " ( ( 12 + 19 ) - 17 ) " ) ); // ( - ( + 12 19 ) 17 )
console.log( parse ( " ( ( 12 + 19 ) * ( 17 - 34 ) ) " ) ); // ( * ( + 12 19 ) ( - 17 34 ) )
console.log( parse ( " ( ( ( 5 + 7 ) + 19 ) * ( 17 - (30 + 4) ) ) " ) ); // ( * ( + ( + 5 7 ) 19 ) ( - 17 ( + 30 4 ) ) )
