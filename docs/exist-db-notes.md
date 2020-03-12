# Notes on eXist-DB

This contains various info and notes about eXist-DB-related matters.


## Install

* eXist-DB 4.6.1 (the Calabash module doesn't like 5.x and I don't know what's wrong)
* xsltforms
* XSLTForms Demo
* XProc Calabash module


This XQuery returns XML (the module itself returns a map, i.e. map {"result":"<p>markup</p>"}):

```XQuery
xquery version "3.1";

import module namespace xmlcalabash = "http://exist-db.org/xquery/xproc/xmlcalabash";

let $out := xmlcalabash:process("xmldb:exist:///db/test/xproc1-test.xpl")

return parse-xml($out?result)
```

