<%
java.util.Map<String,String> map=System.getenv();
for (String key : map.keySet()) {
	out.println(key+"="+map.get(key)+"\n");
}
%>
