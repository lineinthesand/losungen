/* Short but incomprehensible algorithm for calculating the day number in the year
 * taken from http://stackoverflow.com/a/27790471/1573870 */
function getDOY(date) {
    if (typeof(date) == 'undefined') date = new Date;
    var y = date.getFullYear(); 
    var m = date.getMonth()+1; 
    var d = date.getDate(); 
    var DOY = --m*31-(m>1?(1054267675>>m*3-6&7)-(y&3||!(y%25)&&y&15?0:1):0)+d;
    return DOY;
}

/* Get the number of total days in the current year (to determine whether we're in
 * a leap year) */
function getDaysInYear(){
    var date = new Date()
    date.setDate(31);
    date.setMonth(11);
    return getDOY(date);
}


/* Create a rich text formatted string of the losung object passed */
function formatLosung(losung_) {
    var text = "<p>" + losung_.ot_text + "</p>" 
             + "<p align=right style=\"margin-right: 1em\">" + losung_.ot_verse + "</p>"
             + "<p>" + losung_.nt_text + "</p>"
             + "<p align=right style=\"margin-right: 1em\">" + losung_.nt_verse + "</p>";
    return text;
}

