<%
Connection con = null;
Statement st = null;

//CONEXAO PARA HOSPEDAGEM
//Class.forName("org.gjt.mm.mysql.Driver");
//con = DriverManager.getConnection("jdbc:mysql://mysql.fortesystem.net.br/fortesystem16", "fortesystem16", "100amix");
//st=con.createStatement();


//CONEXAO PARA PC-ALMIR
Class.forName("org.gjt.mm.mysql.Driver");
con=DriverManager.getConnection("jdbc:mysql://localhost/photoprisma","root","");
st=con.createStatement();

%>