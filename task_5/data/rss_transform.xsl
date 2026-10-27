<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:yandex="http://news.yandex.ru"
  xmlns:media="http://search.yahoo.com/mrss/">
  
  <xsl:output method="html" encoding="UTF-8" indent="yes"/>
  
  <xsl:template match="/">
    <html>
      <head>
        <meta charset="UTF-8"/>
        <title><xsl:value-of select="rss/channel/title"/></title>
        <style>
          body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
            line-height: 1.6;
          }
          .header {
            text-align: center;
            margin-bottom: 30px;
            padding: 20px;
            background: linear-gradient(135deg, #0066cc, #004499);
            color: white;
            border-radius: 8px;
          }
          .header h1 {
            margin: 0;
            font-size: 2em;
          }
          .header p {
            margin: 10px 0 0 0;
            opacity: 0.9;
          }
          .news-item {
            background: white;
            margin-bottom: 30px;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
          }
          .news-category {
            display: inline-block;
            background-color: #0066cc;
            color: white;
            padding: 4px 12px;
            border-radius: 4px;
            font-size: 0.85em;
            margin-bottom: 10px;
            text-transform: uppercase;
          }
          .news-title {
            margin: 10px 0;
          }
          .news-title a {
            color: #333;
            text-decoration: none;
            font-size: 1.4em;
            font-weight: bold;
          }
          .news-title a:hover {
            color: #0066cc;
          }
          .news-date {
            color: #666;
            font-size: 0.9em;
            margin-bottom: 15px;
          }
          .news-image {
            width: 100%;
            max-width: 600px;
            height: auto;
            margin: 15px 0;
            border-radius: 4px;
          }
          .news-text {
            text-align: justify;
            margin: 15px 0;
          }
          .news-text a {
            color: #0066cc;
          }
          .related-section {
            margin-top: 20px;
            padding-top: 15px;
            border-top: 2px solid #eee;
          }
          .related-title {
            font-size: 1.1em;
            color: #333;
            margin-bottom: 10px;
          }
          .related-item {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
            padding: 8px;
            background-color: #f9f9f9;
            border-radius: 4px;
          }
          .related-item:hover {
            background-color: #f0f0f0;
          }
          .related-image {
            width: 80px;
            height: 60px;
            object-fit: cover;
            margin-right: 12px;
            border-radius: 3px;
          }
          .related-link {
            color: #0066cc;
            text-decoration: none;
            font-size: 0.95em;
          }
          .related-link:hover {
            text-decoration: underline;
          }
        </style>
      </head>
      <body>
        <div class="header">
          <h1><xsl:value-of select="rss/channel/title"/></h1>
          <p><xsl:value-of select="rss/channel/description"/></p>
        </div>
        
        <xsl:for-each select="rss/channel/item">
          <div class="news-item">
            <!-- Категория -->
            <span class="news-category">
              <xsl:value-of select="category"/>
            </span>
            
            <!-- Заголовок с ссылкой -->
            <div class="news-title">
              <a href="{link}" target="_blank">
                <xsl:value-of select="title"/>
              </a>
            </div>
            
            <!-- Дата -->
            <div class="news-date">
              📅 <xsl:value-of select="pubDate"/>
            </div>
            
            <!-- Изображение -->
            <xsl:if test="enclosure/@url">
              <img class="news-image" src="{enclosure/@url}" alt="Изображение новости"/>
            </xsl:if>
            
            <!-- Полный текст новости -->
            <div class="news-text">
              <xsl:value-of select="yandex:full-text" disable-output-escaping="yes"/>
            </div>
            
            <!-- Сопутствующие материалы -->
            <xsl:if test="yandex:related/link">
              <div class="related-section">
                <div class="related-title">📰 Сопутствующие материалы:</div>
                <xsl:for-each select="yandex:related/link">
                  <div class="related-item">
                    <xsl:if test="@img">
                      <img class="related-image" src="{@img}" alt=""/>
                    </xsl:if>
                    <a class="related-link" href="{@url}" target="_blank">
                      <xsl:value-of select="."/>
                    </a>
                  </div>
                </xsl:for-each>
              </div>
            </xsl:if>
          </div>
        </xsl:for-each>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>