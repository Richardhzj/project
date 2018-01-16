function display( matrix ) {
  var letters = [ "A", "B", "C", "D", "E", "F" ]; // used in my 6x6 demo only 
  var size = matrix.length;
  console.log("  a b c d e f "); // ditto 
  for (var row = 0; row < matrix.length; row++) {
    var line = letters[row] + " ";
    for (var col = 0; col < matrix[row].length; col++) {
      line = line + matrix[row][col] + " ";
    }
    console.log( line );
  }
}

// given a size this function returns a size x size matrix of 0's 
// this was also developed in class on Thu for the magic square program
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

// this is what determines whether a cell dies, survives, or becomes alive
// note that we capitalize on the current data representation: cell is 1 or 0
function neighbors(matrix, row, column) {
  var howMany = 0;
  for (var i = row-1; i <= row+1; i++) {
    for (var j = column-1; j <= column+1; j++) {
      if (i < 0 || i >= matrix.length || j < 0 || j >= matrix.length) {
        // nothing
      } else {
        howMany += matrix[i][j];
      }
    }
  }
  howMany = howMany - matrix[row][column]; // don't count yourself
  return howMany;
}

// this is the function that determines the state of the matrix in the new generation
// of necessity this function can't modify the current matrix but needs to build a new one
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

var m = create(6); // my example is six by six 
//[
// [0, 1, 1, 1, 1, 0],
// [1, 0, 0, 0, 1, 0],
// [1, 1, 1, 1, 0, 0],
// [0, 1, 0, 0, 0, 0],
// [0, 0, 0, 0, 0, 0],
// [0, 0, 0, 0, 0, 0]]

// basic program that runs for four iterations 
for (var i = 0; i < 4; i++) {
  m = change(m); // get a new matrix from the old one plus rules 
  display(m); // show matrix 
  console.log("-----------------------"); // separate generations 
}
