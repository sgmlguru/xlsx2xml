# Technical Overview

This describes the overall technical solution for handling course provider information.


## Expected Input Format

Currently, we expect the input file format from a provider to be Excel spreadsheets in Office 2010 or newer format, using a single worksheet. A single row in the Excel spreadsheet is assumed to be a single course, and the columns map to a single piece of information about that course, for example, course ID, course name, location, start date, end date, and so on.

If the provider uses a predefined Excel template, this is handled by default.


## Excel to XML Conversion

The Excel file is converted to the output XML Import 3.0 format in two main stages:

1. The contents of the Excel file are extracted from the Excel archive (Excel files are essentially Zip archives containing a bunch of XML files) and *normalised* into a single large XML file.
2. The normalised XML file is converted to the output XML format using a pipeline consisting of a number of XSLT stylesheets run in sequence.

The columns in the spreadsheet are mapped to an intermediate XML format using a provider-specific mapping file in XML format. This mapping file is used by the conversion pipeline to address provider-specific differences in the source format, so the pipeline itself consists of three main parts:

1. Initial tweaking and processing of the Excel XML format, for example, to normalise shared strings and hyperlinks.
2. Conversion from Excel XML markup to an intermediate XML format using the provider-specific mapping. This requires a complete mapping between the input Excel columns and the intermediate XML format.
3. Conversion of the intermediate XML to the output XML import format.

It follows that if the provider using a predefined Excel template with preset column names, provided by EMG and filled in by the provider, there's no need to map anything - the mapping already exists.


## Mapping Provider Info

The provider mapping file is an XML file that looks like this:

```XML
<?xml version="1.0" encoding="UTF-8"?>
<providers xmlns="http://www.sgmlguru/ns/xproc/steps">
    <provider id="provider ID">
        <item coord="Excel spreadsheet coordinate, i.e. A1"
              source="Excel column name"
              target="Exchange target element"/>
        ...
    </provider>
    ...
</providers>

```

There should be one `provider` element per college, assuming that the college always uses the same Excel format, with the same number of columns, column nams, etc. 

Every column is mapped to an `item` element with three attributes:

* `@coord` is the Excel cell coordinate
* `@source` is the column heading in the source Excel
* `@target` is the matching element in the intermediate XML format

We can automatically generate a provider map in XML format, except for the target element name, which needs to be done manually.

Here's a provider map for Morley College, generated from the Excel source and manually edited to include the target element names:

```
<provider xmlns="http://www.sgmlguru/ns/xproc/steps" id="Morley_College">
    <item coord="A" source="Education Title" target="course-name">Education Title</item>
    <item coord="B" source="Education Type" target="course-field">Education Type</item><!-- FIXME -->
    <item coord="C" source="Link" target="course-link">Link</item>
    <item coord="D" source="Duration" target="duration-time">Duration</item><!-- FIXME -->
    <item coord="E" source="Duration Unit" target="duration-unit">Duration Unit</item><!-- FIXME -->
    <item coord="F" source="School" target="location-description">School</item>
    <item coord="G" source="Programme Area" target="categories-category1">Programme Area</item>
    <item coord="H" source="Subject" target="categories-category2">Subject</item>
    <item coord="I" source="Email Receivers" target="email-receiver">Email Receivers</item><!-- FIXME -->
    <item coord="J" source="Degree" target="course-field">Degree</item><!-- FIXME -->
    <item coord="K" source="Description" target="course-description">Description</item>
    <item coord="L" source="Class Format and Activities" target="course-field">Class Format and Activities</item>
    <item coord="M" source="Qualification" target="qualification-type">Qualification</item><!-- FIXME -->
    <item coord="N" source="Location" target="location-place">Location</item>
    <item coord="O" source="Full Fee" target="event-price">Full Fee</item><!-- FIXME -->
    <item coord="P" source="Conc Fee" target="event-price">Conc Fee</item><!-- FIXME -->
    <item coord="Q" source="Snr Fee" target="event-price">Snr Fee</item><!-- FIXME -->
    <item coord="R" source="Currency" target="event-currency">Currency</item><!-- FIXME -->
    <item coord="S" source="Start Date" target="duration-start">Start Date</item><!-- FIXME -->
</provider>
```

Please note that this is a live example from the proof of concept implementation and subject to change.


## eXist-DB Solution

The provider import application is intended to run in [eXist-DB](http://exist-db.org/exist/apps/homepage/index.html), an open source XML database, the main reason being that the application is wholly developed using XML technology and should therefore run in a native XML environment that supports those technologies out-of-the-box. Additionally, eXist-DB provides a clean REST interface to communicate with its surroundings and is easy to integrate with other tools in the XML stack.

The eXist-DB workflow is intended to be as follows:

1. Provider uploads an Excel file to eXist using a form.
2. Application checks if the provider is already registred and, if so, uses an existing provider map to handle the information.
3. Application presents a form for mapping any remaining (or all) columns. The application provides help to assist in filling in the missing bits.
4. When everything is mapped, the appication converts the Excel input to the output XML format.
5. The converted XML is passed on to EMG via a REST endpoint.


## Handling Updates

If course information needs to be updated, there are several options:

* The source Excel spreadsheet is updated and imported again. This will work even if, say, new columns are added.
* The previously converted Excel file, now in XML Import 3.0 format and stored in the eXist-DB database, is edited in-place and then exported to EMG again. Several options are posible:
    - The XML file is edited in an XML editor auch as *oXygen Author*, using an authoring framework for easy WYSIWY-like editing. oXygen Author can access eXist-DB directly and is itself available as a web application, eliminating the need for a client solution. From a technical point of view, This is by far the safest and most robust solution.
    - The XML file is edited by EMG using their tools, and then reimported to eXist-DB.


