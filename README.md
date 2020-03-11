# README

This contains XSLT stylesheets and pipeline manifests for converting Excel spreadsheets to XML. More specifically, the spreadsheets define courses offered by various colleges.


## Prerequisites

The code in this repository **requires** the [`xproc-batch`](https://github.com/sgmlguru/xproc-batch) repository, cloned as a sibling repo to this one.

The output XML format follows the `XML import 3.0` XML Schema defined in the [`xml-import`](https://github.com/emgdev/xml-import) repository.


## What It Does

This repo contains an *XML manifest file*, `pipelines/poc/poc-xlsx2xml-manifest.xml`, listing a bunch of XSLT stylesheets run in sequence on XML files in a source folder defined by an XProc (in the `xproc-batch` repo) that reads and runs the manifest. For details on that repo, read its documentation.

In short, this is what happens:

1. Convert extracted and normalised Excel XML to an intermediate format defined by `exchange/dtd/fc-exchange.dtd`. The Excel columns are *mapped* to the intermediate XML using an XML mapping file in `mapping/providers.xml`, generated *before* the pipeline is run for the first time.
2. The intermediate XML is further converted to the XML Import 3.0 format.


## The Excel to XML Mapping File

The pipeline requires an XML file to map input Excel spreadsheet columns to an intermediate XML format we call an *exchange format*. This format is described by `exchange/dtd/fc-exchange.dtd`. Therefore, before the pipeline is run for the first time, we need to generate this file.

Most of this mapping file, `mapping/providers.xml`, is generated using an XSLT stylesheet, `xslt/common/UTIL_generate-map-skeleton.xsl`. The output looks like this:

```XML
<provider id="provider-ID">
    <item coord="A1" source="Excel column name" target=""/>
</provider>
```

Each item identifies a heading row cell naming a column in the Excel source. `@coord` contains the Excel grid cell coordinate, `@source` is the contents of that cell, and `@target` is the mapped exchange XML element, left empty by the XSLT. The idea is to manually enter the target element names.

The XSLT acts on a normalised XML version of the input Excel spreadsheet. Normally, this is provided by an XProc step but the XML could also be manually extracted from the Excel zip archive.

Easiest here is to run `xproc/extract-from-xlsx.xpl` from the [`xproc-batch`](https://github.com/sgmlguru/xproc-batch) repository - see the shell script examples in that repository.


## Tests

Some of the pipeline steps have accompanying XSpec unit tests. These are listed in a testing manifest file, `testing/poc/poc-xspec-manifest.xml`. If the XProc option `run-xspecs` is set to 'true', the pipeline will run the XSpec tets in the pipeline.

**NOTE! In order to run the tests, the `debug` option must be set to 'true' as well!**

If you're running the pipeline on multiple input spreadsheets, I recommend you *not* to enable XSpec tests, as these take time, resources, and a lot of disk space to run.
