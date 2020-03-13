# Notes on eXist-DB

This contains various info and notes about eXist-DB-related matters.


## Install

* eXist-DB 4.6.1 (the Calabash module doesn't like 5.x and I don't know what's wrong)
* xsltforms
* XSLTForms Demo
* XProc Calabash module

This XQuery returns XML (the module itself returns a map, i.e. `map {"result":"<p>markup</p>"}`, so we need to read the map entry's value and parse that as XML using `parse-xml($out?result)`):

```XQuery
xquery version "3.1";

import module namespace xmlcalabash = "http://exist-db.org/xquery/xproc/xmlcalabash";

let $input := <input type="xml" port="source" url='xmldb:exist:///db/test/xml/test.xml'/>

let $passthrough := <option name="passthrough" value="myvalue"/>

let $out := xmlcalabash:process("xmldb:exist:///db/test/xproc1-test.xpl",($input,$passthrough))

return parse-xml($out?result)
```

Here, `$passthrough` is an XProc option, passed through to the XSLT as a parameter value. This means that we can create pipelines that accept options.

Erik Siegel's summarised his experiments with the module at (https://github.com/eXist-db/xquery-xproc-xmlcalabash-module/blob/master/docs/xproc/xproc.md).

