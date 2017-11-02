
import java.sql.ResultSet;

void controlEvent(ControlEvent theEvent) {
   if(interfaceReady){
       if(theEvent.isFrom("checkboxMon") ||
          theEvent.isFrom("checkboxDay")){
          submitQuery();  
       }
   
       if(theEvent.isFrom("Temp") ||
          theEvent.isFrom("Wind")){
         //submitQuery();
         queryReady = true;
       }
   
       if(theEvent.isFrom("Submit")) {
          submitQuery();
       }
   
       if(theEvent.isFrom("Close")){
          closeAll();
       }
   }
}

void submitQuery(){
  
  // ######################################################################## //
  // Finish this:
  // write down the sql, given the constraints from the interface
  // ######################################################################## //
  
  String monthSelect = "(";
  
  for (int i = 0; i < checkboxMon.getArrayValue().length; i++) {
        int n = (int)checkboxMon.getArrayValue()[i];
        if(n == 1){
          // if n == 1 means that the box is selected
          // you could use months[i].toLowerCase() to get the lower case of the selected box
          if (monthSelect == "(") {
            monthSelect += "'" + months[i].toLowerCase() + "'";
          }
          else {
            monthSelect += ", '" + months[i].toLowerCase() + "'";
          }
        }
  }
  monthSelect += ")";
  String daySelect = "(";

  for (int i = 0; i < checkboxDay.getArrayValue().length; i++) {
        int n = (int)checkboxDay.getArrayValue()[i];
        if(n == 1) {
          // if n == 1 means that the box is selected
          // you could use days[i].toLowerCase() to get the lower case of the selected box
          if (daySelect == "(") {
            daySelect += "'" + days[i].toLowerCase() + "'";
          }
          else {
            daySelect += ", '" + days[i].toLowerCase() + "'";
          }
        }
  }
  daySelect += ")";

  float maxTemp = rangeTemp.getHighValue();
  float minTemp = rangeTemp.getLowValue();
  
  float maxHum = rangeHumidity.getHighValue();
  float minHum = rangeHumidity.getLowValue();
 
  float maxWind = rangeWind.getHighValue();
  float minWind = rangeWind.getLowValue(); 

  // ######################################################################## //
  // Finish this sql
  // ######################################################################## //

  //String sql = "SELECT * FROM " + table_name;
  String sql = "SELECT * FROM " + table_name + 
                 " where (month IN " + monthSelect + ") AND (day IN " + daySelect + 
                 ") AND (humidity BETWEEN " + minHum + " AND " + maxHum + 
                 ") AND (temp BETWEEN " + minTemp + " AND " + maxTemp +
                 ") AND (wind BETWEEN " + minWind + " AND " + maxWind + ")";
  if (monthSelect == "()" || daySelect == "()") {
    sql = "";
  }
  
  println(sql);
    
  try{
      ResultSet rs = (ResultSet)DBHandler.exeQuery(sql);
      toTable(rs);
  }catch (Exception e){
      println(e.toString());
  }  
}

void toTable(ResultSet rs){
    if(rs == null){
       println("In EventHandler, ResultSet is empty!");
       return;
    }
    int rsSize = -1;
    table.clearRows();
    tableChange = true;
    try{
         rs.beforeFirst();
         int count  = 0;
       while(rs.next()){
         count++;
         TableRow newRow = table.addRow();
         newRow.setInt("id", rs.getInt("id"));

        // ######################################################################## //
        // Finish this:
        // We parse everything else except X and Y for you
        // please finish the part that parsing X and Y to the table
        // ######################################################################## //
        
         newRow.setString("Month", rs.getString("month"));
         newRow.setString("Day", rs.getString("day"));
         newRow.setFloat("Temp", rs.getFloat("temp"));   
         newRow.setFloat("Humidity", rs.getFloat("humidity"));   
         newRow.setFloat("Wind", rs.getFloat("wind"));  
         newRow.setFloat("X", rs.getFloat("X"));
         newRow.setFloat("Y", rs.getFloat("Y"));
         
     }
    }catch (Exception e){
       println(e.toString());
    }finally{
        try{
            rs.close();
        }catch(Exception ex){
            println(ex.toString());
        }
    }
}

void closeAll(){
    DBHandler.closeConnection();
    frame.dispose();
    exit();
}