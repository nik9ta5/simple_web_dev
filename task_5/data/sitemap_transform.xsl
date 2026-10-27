<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" encoding="UTF-8" indent="yes"/>
  
  <xsl:template match="/">
    <html>
      <head>
        <meta charset="UTF-8"/>
        <title>Разделы сайта m24.ru</title>
        <style>
          body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
          }
          h1 {
            color: #333;
            border-bottom: 2px solid #0066cc;
            padding-bottom: 10px;
          }
          table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
          }
          th {
            background-color: #0066cc;
            color: white;
            padding: 12px;
            text-align: left;
          }
          td {
            padding: 10px;
            border-bottom: 1px solid #ddd;
          }
          tr:hover {
            background-color: #f0f0f0;
          }
          a {
            color: #0066cc;
            text-decoration: none;
          }
          a:hover {
            text-decoration: underline;
          }
        </style>
      </head>
      <body>
        <h1>Основные разделы сайта m24.ru</h1>
        <table>
          <thead>
            <tr>
              <th>URL раздела</th>
              <th>Дата последнего изменения</th>
              <th>Периодичность обновления</th>
            </tr>
          </thead>
          <tbody>
            <xsl:for-each select="urlset/url">
              <tr>
                <td>
                  <a href="{loc}" target="_blank"><xsl:value-of select="loc"/></a>
                </td>
                <td><xsl:value-of select="lastmod"/></td>
                <td><xsl:value-of select="changefreq"/></td>
              </tr>
            </xsl:for-each>
          </tbody>
        </table>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>