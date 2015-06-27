<%@page import="servico.ServicoItem"%>
<%@ page import="java.sql.*" %>
<%@ include file="inc/seguranca.jsp" %>
<%@ include file="inc/conexao.jsp" %>

<%@page import="java.util.Calendar"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat;" %>

<jsp:useBean id="usuario" class="cadastro.Usuario" scope="page"></jsp:useBean>

<jsp:useBean id="cliente" class="cadastro.Cliente" scope="page"></jsp:useBean>

<jsp:useBean id="servico" class="servico.Servico" scope="page"></jsp:useBean>

<jsp:useBean id="date" class="java.util.Date" scope="page"/>

<jsp:useBean id="produtos" class="cadastro.Produtos" scope="page"></jsp:useBean><!--Para Seleção de Produtos que compoem a OS -->

<jsp:useBean id="materiais" class="cadastro.Produto" scope="page"></jsp:useBean><!--Para Seleção de materiais que compoem os produtos -->

<jsp:useBean id="os" class="servico.Servico" scope="page"></jsp:useBean>

<jsp:useBean id="caixa" class="caixaloja.Caixa" scope="page"></jsp:useBean>


<%
	GregorianCalendar cal = new GregorianCalendar();
%>

<%
//Instancia um objeto do tipo Statement para ajudar na query
Statement st01 = con.createStatement();
Statement st02 = con.createStatement();
Statement st03 = con.createStatement();
Statement st04 = con.createStatement();
Statement st05 = con.createStatement();
Statement st06 = con.createStatement();
Statement st07 = con.createStatement();


%>

<%
//Instancia um objeto do tipo ResultSet para receber resultado de uma Consulta
ResultSet rs = null;
ResultSet rs01 = null;
ResultSet rs02 = null;
ResultSet rs03 = null;
ResultSet rs04 = null;
ResultSet rs05 = null;
ResultSet rs06 = null;
ResultSet rs07 = null;
%>


<%


//Atribui o nome do usuario ao objeto caixa para realizar
//a consulta posteriormente
caixa.usuario.login = (String)session.getAttribute("usuario");

//Faz a consulta na Base de Dados
rs07 = st07.executeQuery(caixa.verificaCaixa());

if(rs07.next()){


String Telefone  =""; 
String Celular   =""; 
String Operadora =""; 
//Pesquisa todos os clientes Ativos e/ou pesquisa os dados do cliente selecionado na combobox+dados para seleção novamente
if(request.getParameter("clienteID") != null){
	//Atribui o ID ao Objeto da Classe Produto
	cliente.clienteID = Integer.parseInt(request.getParameter("clienteID"));
	rs01 = st01.executeQuery(cliente.clienteID());
	rs03 = st03.executeQuery(cliente.clienteDiferenteID());
	rs04 = st04.executeQuery(cliente.clienteID());
}
else
{
	rs01 = st01.executeQuery(cliente.listaClientesaAtivos());
}

rs02 = st02.executeQuery(os.ultimoServico_ano(cal.get(Calendar.YEAR)));

rs05 = st05.executeQuery(produtos.pesquisaProdutosTodos());//Lista Produtos

rs06 = st06.executeQuery(materiais.listaProdutosAtivos_Selecao());//Lista Produtos

String selecione = "<SELECT name=\"materiais0[]\")\" onchange=\"recuperaCusto(this, valor0)\">";
String selecione2= "";

String opcoes="<option value=\"\">Selecione Material . . .</option>";
String sel2 = "";
String sel3 = "";
while(rs06.next()){ 
 opcoes +=	"<option value=\"" +rs06.getString("produtoID")+"\">"+ rs06.getString("codigo") +" 		- "+rs06.getString("nome") +"</option>";
}

while(rs05.next()){
sel2 += "<option value=\""+rs05.getString("produtoID")+"\">"+rs05.getString("codigo") +" - "+rs05.getString("nome") +"</option>";
}

selecione += opcoes;
selecione += "</SELECT>";

selecione2 = opcoes+"</SELECT>";
String jsct = "";
jsct = "\\"+"\""; 
selecione2 = selecione2.replace("\"", jsct);
selecione2 = "\""+selecione2+"\"";
sel3 = sel2.replace("\"", jsct);
sel3 = "\""+sel3+"\"";

%>


<%
//Trata mensagens
//variaveis que serão utilizadas para verificação
String msg = "";
int numeroMsg;
//verifica se foi passado alguma mensagem via URL
if(request.getParameter("msg") != null){
	numeroMsg = Integer.parseInt(request.getParameter("msg"));
	msg = usuario.mensagem(numeroMsg);
}
%>


 


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-2" />
<title>FORTE SYSTEM</title>
<script src="js/jquery-1.4.3.min.js"></script>
<script type="text/javascript">
function verForm(){
	
}
id=0;//Contorla ID's das tabelas de produtos criados
//Adiciona campos de produtos

function somavalor(obj)//Conforme Usuário insere valores, soma e atribui a campo valor total
{
	var valorProduto = obj.value;
	//alert(valorProduto);
	//alert(form1.valorTotal.value);
	form1.valorProdutoTotal.value = parseFloat(parseFloat(verPonto_Calculo(form1.valorProdutoTotal.value)) +  parseFloat(verPonto_Calculo(valorProduto))).toFixed(2);
	form1.valorTotal.value = parseFloat(parseFloat(verPonto_Calculo(form1.valorProdutoTotal.value))).toFixed(2);
}	


contador=0;
function addRowNovoProduto(tableID) {
	contador++;
    var table = document.getElementById(tableID);
    var rowCount = table.rows.length;
    var row = table.insertRow(rowCount);
	id=rowCount+1;
	var str = "";
    var colCount = table.rows[0].cells.length;
    for(var i=0; i<colCount; i++) {
    	//alert(i);
        var newcell = row.insertCell(i);
        if(i == 2)
        	{
        		var id_concatenado1 = "'dataTable".concat(id).concat("'");
				var id_concatenado2 = "\"dataTable".concat(id).concat("\"");
				//alert(id_concatenado2);
				//alert(i);
        		//var id_concatenado2 
        		//var id_concatenado3
        		
        		var _0 =		"<tr>";
				var _1 =             "<td></td>";
				var _2 = 	    		"<td colspan=\"4\">";
				var _3 =    				"<TABLE id="+id_concatenado2+"  style=\"border-radius:10px; border:1px solid black\" align=\"center\">";
				var _4 = 						        "<TR>";
				var _5 =						        	"<TD><INPUT type=\"checkbox\" name=\"chk[]\"/></TD>";
				var _6 =						        	"<TD>";
				var _7 =						        		"<table border=\"0\">";
				var _8 =						        		"<TR>";
				var _9 =						        			"<TD><SELECT name=\"materiais"+contador+"[]\" )\">";
				var _11 =								                <%=selecione2%>;
				var _12 =								            "</td>";
				var _13 =								            "<TD>";
				var _14 =								        		"Quantidade";
				var _15 =								        	"</td>";
				var _16 =								        	"<td>";
				var _17 =								        		 "<td><INPUT type=\"number\" name=\"QuantidadeR"+contador+"[]\" required step=\"0.01\" style=\"width:75px\" required /></td>";
				var _18 =								        	"</td>";
				var _19 =								        	"<td>";
				var _20 =								        		"Valor";
				var _21 =								        	"</td>";
				var _22 =								        	"<td>";
				var _23 =				    							"<input type=\"number\" pattern=\"(\d{3})([\.])(\d{2})\" name=\"valorMaterial"+contador+"[]\" size=\"5\" required style=\"width:75px; text-align: right;\" value=\"0.00\" step=\"0.01\" min=\"0\" maxlength=\"10\" onchange=\"setTwoNumberDecimal(this);somavalor(this);verPonto();return numero(this.value)\" required=\"required\"/>";
				var _24 =				    						"</td>";
				var _25 =											"<td></td>";
				var _26 =											"<td></td>";
				var _27 =							            "</TR>";
				var _28 =						        		"</table>";
				var _29 =						        	"</TD>";
				var _30 =								"</TR>";
				var _31 =					    "</TABLE>";
				var _32 =					    "</td>";
				var _33 =					    "<td align=\"center\">";
				var _35 =	  						"<img src=\"images/add.png\" style=\"display:inline;width:15px;height:20px;text-indent:-9000em;overflow:hidden;\" title=\"Adicionar Material\" onclick=\"addRow("+id_concatenado1+")\">";
				var _36 =							"<img src=\"images/delete.png\" style=\"display:inline;width:15px;height:20px;text-indent:-9000em;overflow:hidden;\" title=\"Remover Material\" onclick=\"deleteRow("+id_concatenado1+", '1')\">";
				var _37 =   					"</td>";
				var _38 =   		"</tr>";
					        	
	        	str = "".concat(_0).concat(_1).concat(_2).concat(_3).concat(_4).concat(_5).concat(_6).concat(_7).concat(_8).concat(_9).concat(_11).concat(_12).concat(_13).concat(_14).concat(_15).concat(_16).concat(_17).concat(_18).concat(_19).concat(_20).concat(_21).concat(_22).concat(_23).concat(_24).concat(_25).concat(_26).concat(_27).concat(_28).concat(_29).concat(_30).concat(_31).concat(_32).concat(_33).concat(_35).concat(_36).concat(_37).concat(_38);
	        	//alert(str);
	        	newcell.innerHTML = str;	
        	}
        else
        	{
        		newcell.innerHTML = table.rows[0].cells[i].innerHTML;	
        	}
        
        //alert(newcell.childNodes);
        /*switch(newcell.childNodes[0].type) {
            case "text":
                    newcell.childNodes[0].value = "";
                    break;
            case "checkbox":
                    newcell.childNodes[0].checked = false;
                    break;
            case "select-one":
                    newcell.childNodes[0].selectedIndex = 0;
                    break;
        }*/
    }
}
//remove campos de produtos
function deleteRowProduto(tableID) {
    try {
    var table = document.getElementById(tableID);
    var rowCount = table.rows.length;

    for(var i=0; i<rowCount; i++) {
        var row = table.rows[i];
        var chkbox = row.cells[0].childNodes[0];
        if(null != chkbox && true == chkbox.checked) {
            if(rowCount <= 1) {
                //alert("");
                break;
            }
            table.deleteRow(i);
            rowCount--;
            i--;
        }


    }
    }catch(e) {
        alert(e);
    }
}

var tableIDControle = 0;

function addRow(tableID) {
	tableIDControle++;
    var table = document.getElementById(tableID);
    tableIDTeste = tableID;
    var rowCount = table.rows.length;
    var row = table.insertRow(rowCount);
	//alert(rowCount);
    var colCount = table.rows[0].cells.length;

    for(var i=0; i<colCount; i++) {
    			
        		var newcell = row.insertCell(i);
        		newcell.innerHTML = table.rows[0].cells[i].innerHTML;
        		//alert(newcell.childNodes);
        		switch(newcell.childNodes[0].type) {
	            case "text":
	                    newcell.childNodes[0].value = "";
	                    break;
	            case "checkbox":
	                    newcell.childNodes[0].checked = false;
	                    break;
	            case "select-one":
	                    newcell.childNodes[0].selectedIndex = 0;
	                    
	                    break;
        }
        		
    }
    newcell.children[0].rows[0].cells[0].childNodes[1].outerHTML = "<SELECT name=\"materiais[]\" onchange=\"recuperaCusto(this, valor"+tableIDControle+")\")\">"+<%=selecione2%>;
    //newcell.children[0].rows[0].cells[4].childNodes[1].id = "valor"+tableIDControle;
    newcell.children[0].rows[0].cells[5].childNodes[1].id = "valor"+tableIDControle;
}
var contador = 0;
function addRow_(tableID) {
	contador++;
    var table = document.getElementById(tableID);
    tableIDTeste = tableID;
    var rowCount = table.rows.length;
    var row = table.insertRow(rowCount);
	//alert(rowCount);
    var colCount = table.rows[0].cells.length;
	var teste;
    for(var i=0; i<colCount; i++) {
    			
        		var newcell = row.insertCell(i);
        		var innerTudo = "";
        		
        		var _1 =	"<tr>";
        		var _2 = 	"<td>";
        		var _3 = 	"<table>";
        		var	_4 = 		"<tr>";
        		var _5 = 		"<td><INPUT type=\"checkbox\" name=\"chk[]\" id=\"chk"+contador+"\"/></td>";
        		var _6 =					"<TD colspan=\"0\" align=\"center\">";
        		var _7 =						"<SELECT name=\"produtoID[]\" required=\"required\" onchange=\"recuperaCusto(this)\" id=\""+contador+"\">";
        		var _8 =							"<option value=\"\">Selecione Produto. . .</option>";
        		var _9 =							<%=sel3%>;
        		var _10 =								"";
        		var _11 =							"";
        		var _12 =						"</SELECT>"
        		var _13 =					"</TD>"
        		var _14 =					""
        		var _15 =						"";
        		var _16 =					"";
        		var _17 =					"";
        		var _18 =						"";
        		var _19 =						"";
        		var _20 =					"";
        		var _21 =					"";
        		var _22 =						"";
        		var _23 =						 "";
        		var _24 =					"";
        		var _25 =					"<td>";
        		var _26 =					"Quantidade";
        		var _27 =						 "<INPUT type=\"number\" name=\"qtdProduto[]\" min=\"1\" step=\"1\" value=\"1\" size=\"5\" style=\"width:75px; text-align: right;\" onchange=\"Multiplica_(this)\" id=\"qtd"+contador+"\"/>";
        		var _28 =					"</td>";
        		var _29 =					"<td>Valor Produto<input name=\"valorProduto[]\" type=\"text\"  value=\"0.00\" size=\"20\" maxlength=\"10\" onkeypress=\"verPonto(); return numero(this.value)\" required=\"required\" style=\"text-align: right;\" id=\"val"+contador+"\"/></td><td>";
        		var _30 =					"Valor Total";
        		var _31 =						"<input name=\"valorProdutoTotal[]\" type=\"number\" pattern=\"(\d{3})([\.])(\d{2})\" value=\"0.00\" size=\"20\" maxlength=\"10\" onkeypress=\"verPonto(); return numero(this.value)\"  style=\"text-align: right;\" id=\"valT"+contador+"\"/>";
        		var _32 =					"</td>";
        		var _33 =					"<td  id=\"caminho1\">";
        		var _34 = 					"Informa��es Adicionais: ";
        		var _35 =					"</td>";
        		var _36 =					"<td  id=\"caminho2\">";
        		var _37 =						"<input type=\"text\" name=\"infos[]\" value=\"\" />";
        		var _38 =					"</td>";
        		var _39 =				"</tr>";
        		var _77 =				"</table>";
        		var _78 =				"</td>";
        		var _79 =			"</tr>";
        		
        		
        		var str = "".concat(_1).concat(_2).concat(_3).concat(_4).concat(_5).concat(_6).concat(_7).concat(_8).concat(_9).concat(_11).concat(_12).concat(_13).concat(_14).concat(_15).concat(_16).concat(_17).concat(_18).concat(_19).concat(_20).concat(_21).concat(_22).concat(_23).concat(_24).concat(_25).concat(_26).concat(_27).concat(_28).concat(_29).concat(_30).concat(_31).concat(_32).concat(_33).concat(_34).concat(_35).concat(_36).concat(_37).concat(_38).concat(_39).concat(_77).concat(_78).concat(_79);
     
        		newcell.innerHTML = str;//table.rows[0].cells[i].innerHTML = "teste";
        		//alert(newcell.childNodes);
        		switch(newcell.childNodes[0].type) {
	            case "text":
	                    newcell.childNodes[0].value = "";
	                    break;
	            case "checkbox":
	                    newcell.childNodes[0].checked = false;
	                    break;
	            case "select-one":
	                    newcell.childNodes[0].selectedIndex = 0;
	                    break;
        }
        		
    }
    //teste.children[0].rows[0].cells[0].childNodes[1].outerHTML = "<SELECT name=\"materiais"+contador+"[]\"\">"+<%=selecione2%>;
    //newcell.children[0].rows[0].cells[4].childNodes[1].id = "valor"+tableIDControle;
    //newcell.children[0].rows[0].cells[5].childNodes[1].id = "valor"+contador+"[]";
}




function deleteRow(tableID, tipo) {
    try {
    var table = document.getElementById(tableID);
    var rowCount = table.rows.length;

    for(var i=0; i<rowCount; i++) {
        var row = table.rows[i];
        var chkbox = row.cells[0].childNodes[0];
        if(null != chkbox && true == chkbox.checked) {
        	if(rowCount <= 1) {
                //alert("NU+00E3o é psossível remover todas as linhas.");
                break;
            }
        	//if(tipo ==0)
        	//	{
        	var tabela = row.cells[1].childNodes[0].nextSibling;
           	var tabelaRow = tabela.rows[0];
           	//var campo = tabelaRow.cells[8].childNodes[0];
           	var campo = tabelaRow.cells[5].childNodes[1].value;
           	if(campo != null || campo != "")
           		{subtrai(campo);}
        	//	}
        	//else
        	//	{
	        		//var tabela = row.cells[1].childNodes[0];
	               	//var tabelaRow = tabela.rows[1];
	              	//var campo = tabelaRow.cells[8].childNodes[0];
	              	//if(campo.value != null || campo.value != "")
	              	//	{subtrai(campo.value);}
        	//	
        	//	}
        	
           	
            table.deleteRow(i);
            rowCount--;
            i--;
        }


    }
    }catch(e) {
        alert(e);
    }
}

function deleteRow_(tableID, tipo) {
    try {
    var table = document.getElementById(tableID);
    var rowCount = table.rows.length;

    for(var i=0; i<rowCount; i++) {
        var row = table.rows[i];
        var chkbox = row.cells[0].children[0].children[0].children[0].children[0].childNodes[0];//row.cells[0].childNodes[0];
        if(null != chkbox && true == chkbox.checked) {
        	if(rowCount <= 1) {
                //alert("NU+00E3o é psossível remover todas as linhas.");
                break;
            }
        	var id = apenasNumeros(chkbox.id);
        	var total = document.getElementById("valT"+id);
        	subtrai(total.value);
            table.deleteRow(i);
            rowCount--;
            i--;
        }


    }
    }catch(e) {
        alert(e);
    }
}

function recuperaCusto (obj){//recupera pre�o de venda por produto
	var idObj = obj.id;
	var valor = document.getElementById("val"+idObj);
	var valor1 = document.getElementById("valT"+idObj);
	//valor.value = "1000,00";
	$.post('sis_recupera_preco_venda.jsp', {materialID: obj.selectedOptions[0].value}, function(data){
		valor.value=data.trim();
		valor1.value =data.trim();
		multiplica(obj);
	});
}

function multiplica(obj){
	var venda = document.getElementById("val"+obj.id);
	var total = document.getElementById("valT"+obj.id);
	var qtd	  = document.getElementById("qtd"+obj.id);
	var tot = qtd.value * venda.value;
	total.value =  tot.toFixed(2);
	SomaTudoAutom�tico();
}
function Multiplica_(obj){
	var ID = apenasNumeros(obj.id);
	var venda = document.getElementById("val"+ID);
	var total = document.getElementById("valT"+ID);
	var qtd	  = document.getElementById("qtd"+ID);
	var tot = qtd.value * venda.value; 
	total.value = tot.toFixed(2);
	SomaTudoAutom�tico();
}

function apenasNumeros(string) 
{
    var numsStr = string.replace(/[^0-9]/g,'');
    return parseInt(numsStr);
}

function SomaTudoAutom�tico(){
	var tabela = document.getElementById("prod0");
	var rowCount=tabela.rows.length;
	var total = 0;
	var valorAtual = 0;
	var varParc = 0;
	for(i = 0; i < rowCount; i++){
		varParc = document.getElementById("valT"+i);
		try{
			if(isNumber(varParc.value)){
			
				valorAtual = valorAtual + parseFloat(varParc.value);//Recupera o valor das divs de pre�o de custo total para somar ao total de custo
			}
			
		}
		catch (e) {
			// TODO: handle exception
		}
	}
	document.getElementById("valorTotal").value = valorAtual.toFixed(2);
	//venda();
	
}

function isNumber(n) {
    return !isNaN(parseFloat(n)) && isFinite(n);
}

function getMoney(valor){
	return parseFloat(valor)*100;
}



function setTwoNumberDecimal(obj) {
    obj.value = parseFloat(obj.value).toFixed(2);
}


function subtrai(valor)
{
	if(valor != "0.00" && valor != ""){
		//form1.valorProdutoTotal.value = parseFloat(parseFloat(verPonto_Calculo(form1.valorProdutoTotal.value)) - parseFloat(verPonto_Calculo(parseFloat((parseFloat(valor)))).toFixed(2))).toFixed(2);
		var Valtot = form1.valorTotal.value;
		Valtot = parseFloat(Valtot)-parseFloat(valor);
		form1.valorTotal.value = Valtot.toFixed(2);
	}
}

function Multiplica(obj)
{
	//form1.valorTotal.value = parseFloat(parseFloat(verPonto_Calculo(form1.valorTotal.value)) - parseFloat(form1.valorProdutoTotal.value)).toFixed(2);
	//form1.valorProdutoTotal.value =	parseFloat(form1.valorProdutoTotal.value * obj.value).toFixed(2);
	//form1.valorTotal.value = parseFloat(parseFloat(verPonto_Calculo(form1.valorTotal.value)) + parseFloat(form1.valorProdutoTotal.value)).toFixed(2);
}
</script>

<script type="text/javascript" src="js/jquery.js"></script>


<script type="text/javascript" src="js/jquery-1.4.3.min.js"></script>
    <script type="text/javascript" src="js/jquery.pstrength-min.1.2.js"></script>
        <script>
        	$(document).ready(function(){
				$('.password').pstrength();
			});
        </script>

<script type="text/javascript" src="js/interface.js"></script>

<!--[if lt IE 7]>
 <style type="text/css">
 .dock img { behavior: url(iepngfix.htc) }
 </style>
<![endif]-->   

<link href="css/menu.css" rel="stylesheet" type="text/css" />
<link href="css/geral.css" rel="stylesheet" type="text/css" />

<script type="text/javascript">

function verForm(){
	
	if(document.form1.clienteID.value == ""){
		alert("Favor Inserir um cliente para esse Serviço!");
		document.form1.clienteID.focus();
		return false;
	}
	
	if(document.form1.descricao.value == ""){
		alert("Informe detalhes do Serviço!");
		document.form1.descricao.focus();
		return false;
	}
	
	if(document.form1.valor.value == ""){
		alert("Informe o valor do Serviço!");
		document.form1.valor.focus();
		return false;
	}
	
	
	verPonto();
	
	
	
}

function pesquisaCliente(){
	var clienteID = document.form1.clienteID.value;
	window.location.href="sis_insert_nova_os.jsp?clienteID="+clienteID;	
}

</script>


<script type="text/javascript">

//Valida se o Campo é Numérico (COM VÍRGULA " , " )
function numero()	{
	if (event.keyCode<48 && event.keyCode!=44 || event.keyCode>57 && event.keyCode!=44){return false;} 
}

//Verifca se tem "," ao invés de "." e Substitui
function verPonto(){
	var valor = document.form1.valor.value;
		
	valor = valor.replace(",",".");
		
	document.form1.valor.value = valor;
}

function verPonto_Calculo(val){
	var valor = val;
		
	valor = valor.replace(",",".");
		
	return valor;
}

</script>

</head>

<body onload="javascript: document.form1.clienteID.focus()">

<div id="container">

<div id="topo">
 <jsp:include page="inc/menu_superior.jsp" />
</div>


<div id="corpo">
<table width="985" align="center" height="440">
<tr>
 <td height="25" bgcolor="#EEEEEE">
 <input type="button" class="botao" onclick="javascript: window.location.href='sis_view_servicos.jsp'" value="Lista de OS's" />&nbsp;
 <input type="button" class="botao" onclick="javascript: window.location.href='sis_insert_cliente_servico.jsp'" value="+ Incluir Cliente" />
 </td>
</tr>
<tr>
 <td height="25"></td>
</tr>
<tr>
 <td valign="top" align="center">
 <form method="post" name="form1" action="sis_insert_manager_servico.jsp" onsubmit="return verForm(this)">
 <table width="696" align="center" cellpadding="2" cellspacing="2">
  <tr bgcolor="#EEEEEE">
  <td colspan="6" align="center"><strong>NOVO OR&Ccedil;AMENTO</strong><input  name="tipo" type="hidden" value="1" id="tipo"/></td>
  </tr>
  
  <tr><TR><%if(rs02.next()){
  int OSNova = Integer.parseInt(rs02.getString("OS"))+1;%>
  	
  	<td align="left" colspan="3"><strong>OS anterior: <%=rs02.getString("OS")+"/"+rs02.getString("anoServico").substring(0,4)%></strong></td>
  	</TR>
  	<tr>
	 <td align="left"><!-- N&deg; O.S.--></td>
	 
	<td align="left">
		<!-- input type="number" min="0" value="<%=OSNova%>" name="os" style="width:50px" required="required" align="left"/><strong><%="/"+cal.get(Calendar.YEAR) %></strong-->
	</td>
	<%}
	 else
	 { %>
	 	<td align="left"><!-- N&deg; O.S.--></td>
	 	<td align="left">
			<input type="number" min="0" step="1" value="1" name="OS" style="width:50px;text-align: right" required align="left" readonly="readonly"><strong><%="/"+cal.get(Calendar.YEAR) %></strong>
		</td>
	 <%} %>
    <td width="52" align="left">Cliente</td>
    <td width="240" align="left" colspan="2">
    <%if(request.getParameter("clienteID") != null){%>
	   	<select name="clienteID" onchange="pesquisaCliente(<%=request.getParameter("clienteID")%>)" required>
			<option value="<%if(rs01.next()){ %> <%=rs01.getString("clienteID") %><%}%>" selected="selected"><%=rs01.getString("clienteNomeFantasia") %></option>
		    <%while(rs03.next()){ %>
		     	<option value="<%=rs03.getString("clienteID") %>"><%=rs03.getString("clienteNomeFantasia") %></option>
		    <%} %>
	   </select>   
	<%}else{%>
		<select name="clienteID" onchange="pesquisaCliente(<%=request.getParameter("clienteID")%>)" required>
			<option value="">Selecione . . .</option>
		    <%while(rs01.next()){ %>
		     	<option value="<%=rs01.getString("clienteID").trim() %>"><%=rs01.getString("clienteNomeFantasia") %></option>
		    <%} %>
	   </select>   
	<%}%>   
   </td>
  </tr>
  <tr>
    <td width="66" align="left" >Inicio</td>
    <td width="164" align="left"><%= new java.text.SimpleDateFormat("dd/mm/yyyy").format(new java.util.Date())%><input  name="dtInicio" type="hidden" value="<%=new java.util.Date() %>" id="inicio"></input></td>
    <%if(request.getParameter("clienteID") != null){%>
	    <td colspan="2" align="left">
	    <%if(rs04.next())//Verifica se tem os dados a serem exibidos de contato do cliente
		{
			try
			{
				if(!rs04.getString("clienteTelefone").isEmpty())
				{
				 	Telefone = rs04.getString("clienteTelefone");
				}
				if(!rs04.getString("clienteCelular").isEmpty())
				{
				 	Celular = rs04.getString("clienteCelular");
				}
				if(!rs04.getString("clienteOperadora").isEmpty())
				{
				 	Operadora = rs04.getString("clienteOperadora");
				}
			}catch(Exception ex){}
			
		}%>
	    Tel: <%=Telefone %>  &nbsp;&nbsp;&nbsp;
	    Cel: <%=Celular %> <%=Operadora %> 
	    </td>
    <%} %>
    	
    </tr>
	<tr bgcolor="#F9F6F2">
	  	<TD>Previsao</TD>
    	<TD><input type="date" value="" id="previsao" name="previcao" required></TD>

	    <td align="left">VALOR VENDA</td>
	    <td align="left" colspan="6"><font color="#009900"><strong><input id="valorTotal" name="valorTotal" type="text" required="required" value="" size="20" maxlength="10" onkeypress="verPonto(); return numero(this.value)" style="text-align: right;" /></strong></font></td>
	</tr>
	<tr>
	<td colspan="" align="center">
				<img src="images/add.png" style="display:block;width:15px;height:20px;text-indent:-9000em;overflow:hidden;" title="Adicionar Produto" onclick="addRow_('prod0')">
				<img src="images/delete.png" style="display:block;width:15px;height:20px;text-indent:-9000em;overflow:hidden;" title="Remover Produto" onclick="deleteRow_('prod0')">
	</td>
	<td colspan="4"> 
		<table  style="border-radius:15px; border:1px solid black; width: 100%;" align="center" cellpadding="2" cellspacing="2" id="prod0">
			<tr>
				<td>
				<table>
				<tr>
					<td><input type="checkbox" name="chk[]" id="chk0"/></td>
					<td colspan="0" align="center">
						<select name="produtoID[]" required="required" onchange="recuperaCusto(this)" id="0">
							<option value="">Selecione Produto. . .</option>
							<%=sel2 %>
						</select>
					</td>
					<td>
					Quantidade
						 <input type="number" name="qtdProduto[]" min="1" step="1" value="1" size="5" style="width:75px; text-align: right;" onchange="Multiplica_(this)" id="qtd0"/>
					</td>
					<td>
					Valor Produto
						 <input name="valorProduto[]" type="text"  value="0.00" size="20" maxlength="10" onkeypress="verPonto(); return numero(this.value)" required="required" style="text-align: right;" id="val0" onchange=""/>
					</td>
					<td>
					Valor Total
						 <input name="valorProdutoTotal[]" type="text"  value="0.00" size="20" maxlength="10" onkeypress="verPonto(); return numero(this.value)" required="required" style="text-align: right;" id="valT0" onchange=""/>
					</td>
					<td  id="caminho1">
						Informa��es Adicionais: 
					</td>
					<td id="caminho2" width="150px">
						<input type="text" name="infos[]" value="" />
					</td>
				</tr>
				</table>
				</td>
			</tr>
		</table>
	</td>
	</tr>
	</table>
	 
	 <table width="1023px" align="center" cellpadding="2" cellspacing="2">
	  <tr>
	  	 <td colspan="4" align="center">
	    	<pre style="white-space:pre-line; width:1023px; text-align:left"></pre>   </td>
  		</tr>
	   <tr bgcolor="#FFFF99">
		   <td align="left" colspan="4">Descri&ccedil;&atilde;o do Servi&ccedil;o</td>
	  	</tr>
	  <tr>
	   <td align="center" colspan="4"><textarea name="descricao" required></textarea></td>
	  </tr>
	  <tr>
	     <input name="valor" type="hidden" value="0.00" size="20" maxlength="10" onkeypress="verPonto(); return numero(this.value)"/>
	     <td align="left" colspan="2"><input type="submit" name="CADASTRAR" value="Cadastrar" class="botao" />
	     </td>
     </tr>
	  <tr>
	    <td align="left">&nbsp;</td>
	    <td align="left">&nbsp;</td>
	    <td align="left">&nbsp;</td>
	    <td align="left">&nbsp;</td>
	  </tr>
	 </table>
	 </td>
	</tr>
	<input type="hidden" value="<%=cal.get(Calendar.YEAR)%>" name="anoServico"/>
	<%}
else
	{
		response.sendRedirect("sis_view_servicos.jsp?msg=10");
	}%>
	</form>
<tr>
 <td height="25" bgcolor="#EEEEEE"> </td>
</tr>

</table>

</div>
<div id="rodape2"><jsp:include page="inc/rodape.jsp" /></div>
</div>
<script type="text/javascript">
	
	$(document).ready(
		function()
		{
			$('#dock').Fisheye(
				{
					maxWidth: 50,
					items: 'a',
					itemsText: 'span',
					container: '.dock-container',
					itemWidth: 40,
					proximity: 50,
					halign : 'center'
				}
			)
		}
	);

</script>

</body>
</html>