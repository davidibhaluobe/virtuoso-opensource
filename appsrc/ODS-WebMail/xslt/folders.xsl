<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:include href="common.xsl"/>
  <!-- ====================================================================================== -->
  <xsl:template match="page">
    <xsl:choose>
      <xsl:when test="messages/direction = '1'">
        <xsl:variable name="next_ord" select="0"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="next_ord" select="1"/>
      </xsl:otherwise>
    </xsl:choose>
    <form name="f1" action="folders.vsp" method="post">
      <xsl:call-template name="hid_sid"/>
      <input type="hidden" name="bp">
        <xsl:attribute name="value"><xsl:value-of select="bp"/></xsl:attribute>
      </input>
      <input type="hidden" name="fa">
        <xsl:attribute name="value">cnf</xsl:attribute>
      </input>
      <table width="100%" border="0" cellpadding="0" cellspacing="0" class="content">
        <thead>
          <tr>
            <th width="60%">Folders</th>
            <th align="right">Mails</th>
            <th align="right">New</th>
            <th align="right">Size</th>
            <th align="center" colspan="3" width="15%">Action</th>
          </tr>
        </thead>
        <tbody>
          <xsl:apply-templates select="folders" mode="list"/>
        </tbody>
        <xsl:call-template name="calc_size"/>
      </table>
      <br/>
      <xsl:apply-templates select="folders" mode="combo"/>
    </form>
  </xsl:template>
  <!-- ====================================================================================== -->
  <xsl:template match="folders" mode="list">
    <xsl:for-each select="folder">
      <tr>
        <xsl:call-template name="LH"/>
        <td class="clear">
          <xsl:apply-templates select="ftree/fnode"/>
          <xsl:call-template name="nbsp"/>
          <xsl:call-template name="make_href">
            <xsl:with-param name="url">box.vsp</xsl:with-param>
            <xsl:with-param name="label"><xsl:value-of select="name"/></xsl:with-param>
            <xsl:with-param name="title">Select folder <xsl:value-of select="name"/></xsl:with-param>
            <xsl:with-param name="params">bp=<xsl:value-of select="folder_id"/>,,,</xsl:with-param>
          </xsl:call-template>
        </td>
        <td class="clear" align="right">
          <xsl:value-of select="all_cnt"/>
        </td>
        <td class="clear" align="right">
          <xsl:value-of select="new_cnt"/>
        </td>
        <td class="clear" align="right">
          <xsl:call-template name="size2str">
            <xsl:with-param name="size" select="all_size"/>
            <xsl:with-param name="mode" select="0"/>
          </xsl:call-template>
          <xsl:call-template name="nbsp"/>
        </td>
        <td class="clear" nowrap="nowrap">
          <xsl:if test="folder_id > 99">
            <xsl:call-template name="make_href">
              <xsl:with-param name="url">tools.vsp</xsl:with-param>
              <xsl:with-param name="params">tp=<xsl:value-of select="folder_id"/>,2</xsl:with-param>
              <xsl:with-param name="label">Empty Folder</xsl:with-param>
              <xsl:with-param name="img">/oMail/i/trash_16.png</xsl:with-param>
              <xsl:with-param name="img_label"> Empty</xsl:with-param>
              <xsl:with-param name="class">button</xsl:with-param>
            </xsl:call-template>
          </xsl:if>
          <xsl:call-template name="nbsp"/>
        </td>
        <td class="clear" nowrap="nowrap">
          <xsl:if test="folder_id > 130">
            <xsl:call-template name="make_href">
              <xsl:with-param name="url">tools.vsp</xsl:with-param>
              <xsl:with-param name="params">tp=<xsl:value-of select="folder_id"/>,0</xsl:with-param>
              <xsl:with-param name="label">Edit Folder</xsl:with-param>
              <xsl:with-param name="img">/oMail/i/edit_16.png</xsl:with-param>
              <xsl:with-param name="img_label"> Edit</xsl:with-param>
              <xsl:with-param name="class">button</xsl:with-param>
            </xsl:call-template>
          </xsl:if>
          <xsl:call-template name="nbsp"/>
        </td>
        <td class="clear" nowrap="nowrap">
          <xsl:if test="folder_id > 130">
            <xsl:call-template name="make_href">
              <xsl:with-param name="url">tools.vsp</xsl:with-param>
              <xsl:with-param name="params">tp=<xsl:value-of select="folder_id"/>,1</xsl:with-param>
              <xsl:with-param name="label">Delete Folder</xsl:with-param>
              <xsl:with-param name="img">/oMail/i/del_16.png</xsl:with-param>
              <xsl:with-param name="img_label"> Delete</xsl:with-param>
              <xsl:with-param name="class">button</xsl:with-param>
            </xsl:call-template>
          </xsl:if>
          <xsl:call-template name="nbsp"/>
        </td>
      </tr>
      <xsl:apply-templates select="folders" mode="list"/>
    </xsl:for-each>
  </xsl:template>
  <!-- ====================================================================================== -->
  <xsl:template match="ftree/fnode">
    <xsl:choose>
      <xsl:when test=". = 'F'">
        <img src="/oMail/i/re_t_cl.gif" align="top"/>
      </xsl:when>
      <xsl:when test=". = '-'">
        <img src="/oMail/i/re_g_cl.gif" align="top"/>
      </xsl:when>
      <xsl:when test=". = 'I'">
        <img src="/oMail/i/re_l.gif" align="top"/>
        <img src="/oMail/i/c.gif" align="top" height="1" width="10"/>
      </xsl:when>
      <xsl:otherwise>
        <img src="/oMail/i/c.gif" align="top" height="1" width="10"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- ====================================================================================== -->
  <xsl:template match="folders" mode="combo">
    <table class="content" cellpadding="0" cellspacing="0" width="100%">
      <thead>
        <tr>
          <th>Create new folder</th>
        </tr>
      </thead>
      <tr>
        <td>
          <label>
	        Name:
	        <input type="text" name="fname"/>
          </label>
          <xsl:call-template name="nbsp"/> in  <xsl:call-template name="nbsp"/>
          <select name="pid">
            <xsl:apply-templates select="folder"/>
          </select>
          <xsl:call-template name="nbsp"/>
          <xsl:call-template name="make_href">
            <xsl:with-param name="url">javascript: document.f1.submit();</xsl:with-param>
            <xsl:with-param name="label">Create Folder</xsl:with-param>
            <xsl:with-param name="img">/oMail/i/add_16.png</xsl:with-param>
            <xsl:with-param name="img_label"> Create</xsl:with-param>
            <xsl:with-param name="class">button</xsl:with-param>
          </xsl:call-template>
        </td>
      </tr>
    </table>
  </xsl:template>
  <!-- ====================================================================================== -->
  <xsl:template match="folder">
    <option>
      <xsl:attribute name="value"><xsl:value-of select="folder_id"/></xsl:attribute>
      <xsl:value-of select="level/@str"/>
      <xsl:value-of select="name"/>
    </option>
    <xsl:apply-templates select="folders/folder"/>
  </xsl:template>
  <!-- ====================================================================================== -->
  <xsl:template name="calc_size">
    <tfoot>
      <tr>
        <th style="text-align: right;">Total:</th>
        <th style="text-align: right;">
          <xsl:value-of select="sum(//folders/folder/all_cnt)"/>
        </th>
        <th style="text-align: right;">
          <xsl:value-of select="sum(//folders/folder/new_cnt)"/>
        </th>
        <th style="text-align: right;">
          <xsl:call-template name="size2str">
            <xsl:with-param name="size" select="sum(//folders/folder/all_size)"/>
          </xsl:call-template>
          <xsl:call-template name="nbsp"/>
        </th>
        <th colspan="3">
          <xsl:call-template name="nbsp"/>
        </th>
      </tr>
    </tfoot>
  </xsl:template>
</xsl:stylesheet>
