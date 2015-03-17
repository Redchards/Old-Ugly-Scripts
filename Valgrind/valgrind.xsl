<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <html>
  <body>
    <h2>Valgrind 3.0.1</h2>
    <xsl:apply-templates/> 
  </body>
  </html>
</xsl:template>

<xsl:template match="protocolversion">
Protocol Version: <span style="color:#ff0000">
<xsl:value-of select="."/></span>
<br/><br/>
</xsl:template>

<xsl:template match="preamble/line">
 <span style="color:#666666">
 <xsl:value-of select="."/></span>
 <br/>
</xsl:template>

<xsl:template match="pid">
<br/>
 <table width="20%" border="0" cellpadding="2" cellspacing="2">
  <tr>
    <td width="60%">PID: </td>
    <td style="color:#0000ff" align="left">
        <xsl:value-of select="."/>
    </td>
  </tr>
 </table>
</xsl:template>

<xsl:template match="ppid">
 <table width="20%" border="0" cellpadding="2" cellspacing="2">
  <tr>
    <td width="60%">PPID: </td>    
    <td style="color:#0000ff" align="left">
       <xsl:value-of select="."/>
    </td>
  </tr>
 </table> 
</xsl:template>

<xsl:template match="tool">
 <table width="20%" border="0" cellpadding="2" cellspacing="2">
  <tr>
    <td width="60%">Valgrind Tool: </td>
    <td style="color:#0000ff" align="left">
      <xsl:value-of select="."/>
    </td>
  </tr>
 </table> 
</xsl:template>

<xsl:template match="args">
 <table width="60%" border="0" cellpadding="2" cellspacing="2">
  <tr>
    <td width="20%">Command Executed: </td>
    <td width="80%"><span style="color:#0000ff"><xsl:value-of select="vargv/exe"/></span>
     <xsl:for-each select="vargv/arg">
       <span style="color:#0000ff"><xsl:value-of select="."/> </span>
     </xsl:for-each>  
       <span style="color:#0000ff"><xsl:value-of select="argv/exe"/></span>
    </td>
  </tr>
 </table> 
</xsl:template>

<xsl:template match="status">
<h4 style="color:#336600"><u>STATUS:</u></h4>
 <table width="60%" border="0" cellpadding="2" cellspacing="2">
  <tr>
    <td width="20%">State: </td>
    <td width="80%" style="color:#0000ff"><xsl:value-of select="state"/></td>
  </tr>
  <tr>
    <td width="20%">Time: </td>
    <td width="80%" style="color:#0000ff"><xsl:value-of select="time"/></td>
  </tr>
 </table> 
</xsl:template>

<xsl:template match="error">
<h4 style="color:#ff0000"><u>ERROR:</u></h4>
 <table width="60%" border="0" cellpadding="2" cellspacing="2">
  <tr>
    <td width="20%">Unique: </td>
    <td width="80%" style="color:#0000ff" align="left">
      <xsl:value-of select="unique"/>
    </td>
  </tr>
  <tr>
      <td width="20%">Tid: </td>
      <td width="80%" style="color:#0000ff" align="left">
        <xsl:value-of select="tid"/>
      </td>
  </tr>
  <tr>
      <td width="20%">Kind: </td>
      <td width="80%" style="color:#0000ff" align="left">
        <xsl:value-of select="kind"/>
      </td>
  </tr>
  <tr>
      <td width="20%">What: </td>
      <td width="80%" style="color:#0000ff" align="left">
        <xsl:value-of select="what"/>
      </td>
  </tr>
  <xsl:if test="leakedbytes">
  <tr>
      <td width="20%">Leaked Bytes: </td>
      <td width="80%" style="color:#0000ff" align="left">
        <xsl:value-of select="leakedbytes"/>
      </td>
  </tr>
  </xsl:if>
  <xsl:if test="leakedblocks">
  <tr>
      <td width="20%">Leaked Blocks: </td>
      <td width="80%" style="color:#0000ff" align="left">
        <xsl:value-of select="leakedblocks"/>
      </td>
  </tr>
  </xsl:if>
 </table> 
 <xsl:apply-templates select="stack"/> 
 <xsl:apply-templates select="auxwhat"/>
</xsl:template>

<xsl:template match="stack">
<h4 style="color:#336600"><u> STACK: </u></h4>
<table width="60%" border="0" cellpadding="2" cellspacing="2">
 <tr>
   <td width="5%" align="left"> IP </td>
   <td width="20%" align="left"> Obj </td>
   <td width="10%" align="left"> Function </td>
   <td width="20%" align="left"> Directory </td>
   <td width="5%" align="left"> File </td>
   <td width="5%" align="left"> Line </td>
 </tr>
 <xsl:for-each select="frame">
 <tr>
   <td width="5%" style="color:#0000ff" align="left"><xsl:value-of select="ip"/></td>
   <td width="20%" style="color:#0000ff" align="left"><xsl:value-of select="obj"/></td>
   <td width="10%" style="color:#0000ff" align="left"><xsl:value-of select="fn"/></td>
   <xsl:if test="dir">
   <td width="20%" style="color:#0000ff" align="left"><xsl:value-of select="dir"/></td>
   </xsl:if>
   <xsl:if test="file">
   <td width="5%" style="color:#0000ff" align="left"><xsl:value-of select="file"/></td>
   </xsl:if>
   <xsl:if test="line">
   <td width="5%" style="color:#0000ff" align="left"><xsl:value-of select="line"/></td>
   </xsl:if>
 </tr>
 </xsl:for-each>
 </table>
</xsl:template>

<xsl:template match="auxwhat">
<h4 style="color:#336600"><u>AUXWHAT:</u></h4>
 <table width="40%" border="0" cellpadding="2" cellspacing="2">
  <tr>
   <td><xsl:value-of select="."/></td>
  </tr>
 </table>
</xsl:template>

<xsl:template match="errorcounts">
<h4 style="color:#336600"><u> ERRORCOUNTS: </u></h4>
<table width="30%" border="0" cellpadding="2" cellspacing="2">
 <tr>
   <td width="10%" align="left"> Count </td>
   <td width="20%" align="left"> Unique </td>
 </tr>
 <xsl:for-each select="pair">
  <tr>
    <td style="color:#0000ff" align="left"><xsl:value-of select="count"/></td>
    <td style="color:#0000ff" align="left"><xsl:value-of select="unique"/></td>
 </tr>
 </xsl:for-each>
 </table>
</xsl:template>

<xsl:template match="suppcounts">
<h5 style="color:#336600"><u> SUPPCOUNTS: </u></h5>
<table width="30%" border="0" cellpadding="2" cellspacing="2">
 <tr>
   <td width="10%" align="left"> Count </td>
   <td width="20%" align="left"> Name </td>
 </tr>
 <xsl:for-each select="pair">
  <tr>
    <td style="color:#0000ff" align="left"><xsl:value-of select="count"/></td>
    <td style="color:#0000ff" align="left"><xsl:value-of select="name"/></td>
 </tr>
 </xsl:for-each>
 </table>
</xsl:template>

</xsl:stylesheet>
