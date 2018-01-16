function display( matrix ) {
  var letters = [ "A", "B", "C", "D", "E", "F" ]; 
  var size = matrix.length;
  console.log("  a b c d e f "); 
  for (var row = 0; row < matrix.length; row++) {
    var line = letters[row] + " ";
    for (var col = 0; col < matrix[row].length; col++) {
      line = line + matrix[row][col] + " ";
    }
    console.log( line );
  }
}

function create( size ) {
  var matrix = [];
  for (var row = 0; row < size; row++) {
    var numbers = [];
    for (var col = 0; col < size; col++) {
      numbers.push( Math.round(Math.random()) );
    }
    matrix.push( numbers );
  }
  return matrix;
}

function neighbors(matrix, row, column) {
  var howMany = 0;
  for (var i = row-1; i <= row+1; i++) {
    for (var j = column-1; j <= column+1; j++) {
      if (i < 0 || i >= matrix.length || j < 0 || j >= matrix.length) {
      
      } else {
        howMany += matrix[i][j];
      }
    }
  }
  howMany = howMany - matrix[row][column]; 
  return howMany;
}

function change(m) {
  var result = create(m.length);
  for (var i = 0; i < m.length; i++) {
    for (var j = 0; j < m.length; j++) {
      var n = neighbors(m, i, j);
      if (m[i][j] == 0) {
        if (n == 3) {
          result[i][j] = 1;
        } else {
          result[i][j] = 0;
        }
      } else {
        if (n <= 1 || n >= 4) {
          result[i][j] = 0;
        } else {
          result[i][j] = 1;
        }
      }
    }
  }
  return result;
}

var m = create(6); 

for (var i = 0; i < 4; i++) {
  m = change(m); // get a new matrix from the old one plus rules 
  display(m); // show matrix 
  console.log("-----------------------"); // separate generations 
}
