# Notes on eXist-DB

This contains various info and notes about eXist-DB-related matters.


## Calabash Module for eXist

* eXist-DB 5.2.0
* xsltforms
* XProc Calabash module - you'll need to clone the Git repo at (https://github.com/eXist-db/xquery-xproc-xmlcalabash-module) and build the module from source using `mvn clean package -DskipTests`

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


### Conclusions

The module is not ready for prime time, as quite a few steps simply won't work in eXist-DB.


## XQuery-based

It's relatively easy to do an XQ module that runs the pipeline as listed by a manifest. See the `xquery` contents for details - `modules` contains an XQuery module with the necessary functions.

We'll also need a function that unzips and normalises the Excel xlsx sources.
