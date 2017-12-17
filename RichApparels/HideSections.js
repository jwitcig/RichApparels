var styleTag = document.createElement("style");
styleTag.textContent =
  '.mobile_nav {'
+   'display:none !important;'
+   'line-height: 0;'
+   'height: 0;'
+   'overflow: hidden;'
+ '}'

+ 'header, footer {'
+   'display:none !important;'
+   'line-height: 0;'
+   'height: 0;'
+   'overflow: hidden;'
+ '}'

+ 'body {'
+   'margin-top: 3em !important;'
+   'margin-bottom: 0 !important;'
+ '}'

+ '.custom_content {'
+   'padding-top: 2em;'
+ '}'

+ 'section.content {'
+   'padding-bottom:0;'
+ '}'

+ '.custom_content h1 {'
+   'display:none !important;'
+ '}';
document.documentElement.appendChild(styleTag);
