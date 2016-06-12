<!--
    Author: Sarven Capadisli <info@csarven.ca>
    Author URI: http://csarven.ca/#i

    Description: XSLT for GPX to RDFa
-->
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://exslt.org/math"
    xmlns:gpx="http://www.topografix.com/GPX/1/1"
    xmlns:gpxx="http://www.garmin.com/xmlschemas/GpxExtensions/v3"
    xmlns:gpxtpx="http://www.garmin.com/xmlschemas/TrackPointExtension/v1"
    xmlns="http://www.w3.org/1999/xhtml"
    xpath-default-namespace="http://www.topografix.com/GPX/1/1"
    exclude-result-prefixes="xs gpx gpxx gpxtpx"
    >
    <xsl:output include-content-type="no" method="xhtml" omit-xml-declaration="yes" encoding="utf-8" indent="yes"/>

    <!-- XXX: This time value appears to be added by fit2gpx. -->
    <xsl:variable name="metadataTime" select="gpx/metadata/time"/>
    <xsl:variable name="minLat" select="gpx/metadata/bounds/@minlat"/>
    <xsl:variable name="minLon" select="gpx/metadata/bounds/@minlon"/>
    <xsl:variable name="maxLat" select="gpx/metadata/bounds/@maxlat"/>
    <xsl:variable name="maxLon" select="gpx/metadata/bounds/@maxlon"/>

    <xsl:variable name="centreLat" select="($minLat + $maxLat) div 2.0"/>
    <xsl:variable name="centreLon" select="($minLon + $maxLon) div 2.0"/>

<!-- tile.osm     <xsl:variable name="metadataBounds" select="concat($minLat, ',', $minLon, ',', $maxLat, ',', $maxLon)"/>
 -->    <xsl:variable name="metadataBounds" select="concat($minLon, ',', $minLat, ',', $maxLon, ',', $maxLat)"/>


    <xsl:template match="/">
<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
<xsl:text>
</xsl:text>
<html lang="en" xml:lang="en" xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta charset="utf-8" />
        <title></title>
        <meta content="width=device-width, initial-scale=1" name="viewport" />
        <link href="https://dokie.li/media/css/basic.css" rel="stylesheet" media="all" title="Basic" />
        <link href="https://dokie.li/media/css/do.css" media="all" rel="stylesheet" />
        <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css" media="all" rel="stylesheet" />
        <link href="https://dokie.li/media/css/editor.css" media="all" rel="stylesheet" />
        <script src="https://dokie.li/scripts/simplerdf.js"></script>
        <script src="https://dokie.li/scripts/medium-editor.min.js"></script>
        <script src="https://dokie.li/scripts/medium-editor-tables.min.js"></script>
        <script src="https://dokie.li/scripts/do.js"></script>

    </head>

    <body about="" prefix="rdf: http://www.w3.org/1999/02/22-rdf-syntax-ns# rdfs: http://www.w3.org/2000/01/rdf-schema# owl: http://www.w3.org/2002/07/owl# xsd: http://www.w3.org/2001/XMLSchema# dcterms: http://purl.org/dc/terms/ foaf: http://xmlns.com/foaf/0.1/ v: http://www.w3.org/2006/vcard/ns# pimspace: http://www.w3.org/ns/pim/space# cc: http://creativecommons.org/ns# skos: http://www.w3.org/2004/02/skos/core# prov: http://www.w3.org/ns/prov# schema: https://schema.org/ rsa: http://www.w3.org/ns/auth/rsa# cert: http://www.w3.org/ns/auth/cert# cal: http://www.w3.org/2002/12/cal/ical# wgs: http://www.w3.org/2003/01/geo/wgs84_pos# org: http://www.w3.org/ns/org# biblio: http://purl.org/net/biblio# bibo: http://purl.org/ontology/bibo/ book: http://purl.org/NET/book/vocab# ov: http://open.vocab.org/terms/ doap: http://usefulinc.com/ns/doap# dbr: http://dbpedia.org/resource/ dbp: http://dbpedia.org/property/ sio: http://semanticscience.org/resource/ opmw: http://www.opmw.org/ontology/ deo: http://purl.org/spar/deo/ doco: http://purl.org/spar/doco/ cito: http://purl.org/spar/cito/ fabio: http://purl.org/spar/fabio/ oa: http://www.w3.org/ns/oa# solid: http://www.w3.org/ns/solid/terms# sdmx:http://purl.org/linked-data/sdmx# sdmx-dimension: http://purl.org/linked-data/sdmx/2009/dimension# gi: http://reference.data.gov.uk/id/gregorian-instant/ qudt-quantity: http://qudt.org/vocab/quantity#" typeof="schema:CreativeWork sioc:Post prov:Entity">
        <main>
            <article about="" typeof="schema:Article">
                <table id="box-{$metadataBounds}">
                    <caption>Activity at <a href="http://www.openstreetmap.org/?minlon={$minLon}&amp;minlat={$minLat}&amp;maxlon={$maxLon}&amp;maxlat={$maxLat}"><xsl:value-of select="$metadataBounds"/></a></caption>
                    <xsl:apply-templates select="gpx/trk/trkseg"/>
                </table>

                <figure id="osm-{$metadataBounds}">
<!--
            XXX: http://a.tile.openstreetmap.org/{$osmBoundingBox}
            <xsl:variable name="osmBoundingBox">
                <xsl:call-template name="tilename">
                    <xsl:with-param name="lat" select="$centreLat"/>
                    <xsl:with-param name="lon" select="$centreLon"/>
                    <xsl:with-param name="zoom" select="13"/>
                </xsl:call-template>
            </xsl:variable>
            <img src="http://a.tile.openstreetmap.org/{$osmBoundingBox}.png"/>
 -->
 <!-- timbl: http://render.openstreetmap.org/cgi-bin/export?bbox=141.362637,43.052583,141.390454,43.067100&scale=12724&format=svg&layers=C -->
<!-- http://render.openstreetmap.org/cgi-bin/export?bbox=46.949716111,7.441299664,46.975442100,7.467467798&scale=12724&format=svg&layers=C -->
 <!-- width="640" height="640" -->
                    <object type="image/svg+xml" data="http://render.openstreetmap.org/cgi-bin/export?bbox={$metadataBounds}&amp;scale=100000&amp;format=svg"></object>
                    <figcaption>Activity at  ..</figcaption>
                </figure>
            </article>
        </main>
    </body>
</html>
    </xsl:template>

    <xsl:template match="gpx/trk/trkseg">
        <thead>
            <tr>
                <th>Time</th><th>Latitude</th><th>Longitude</th><th>Elevation</th>
                <xsl:if test="trkpt[1]/extensions/gpxtpx:TrackPointExtension/gpxtpx:hr">
                    <th>Heart rate</th>
                </xsl:if>
            </tr>
        </thead>
        <tfoot>
            <tr><td colspan="4">Elevation is meters above sea level. Heart rate is beats per minute.</td></tr>
            <tr><td colspan="4">http://www.openstreetmap.org/?minlon=7.441299664&amp;minlat=46.949716111&amp;maxlon=7.467467798&amp;maxlat=46.975442100</td></tr>
        </tfoot>
        <tbody>
            <xsl:apply-templates select="trkpt"/>
        </tbody>
    </xsl:template>

    <xsl:template match="trkpt">
        <xsl:variable name="lat" select="@lat"/>
        <xsl:variable name="lon" select="@lon"/>
        <xsl:variable name="time" select="time"/>
        <!-- XXX: Is elevation value always present in GPX? -->
        <xsl:variable name="ele" select="ele"/>

        <xsl:variable name="timePeriod" select="replace($time, 'Z', '')"/>

        <tr about="http://example.org/{$metadataBounds}/{time};{$lat},{$lon};{$ele}" typeof="qb:Observation">
            <td rel="sdmx-dimension:timePeriod" resource="http://reference.data.gov.uk/id/gregorian-instant/{$timePeriod}"><xsl:value-of select="$time"/></td>
            <td property="wgs:lat" datatype="xsd:decimal"><xsl:value-of select="$lat"/></td>
            <td property="wgs:lon" datatype="xsd:decimal"><xsl:value-of select="$lon"/></td>
            <td property="wgs:alt" datatype="xsd:decimal"><xsl:value-of select="$ele"/></td>

            <xsl:apply-templates select="extensions"/>
        </tr>
    </xsl:template>


    <xsl:template match="extensions">
        <xsl:apply-templates select="gpxtpx:TrackPointExtension"/>
    </xsl:template>

    <xsl:template match="gpxtpx:TrackPointExtension">
        <xsl:apply-templates select="gpxtpx:hr"/>
    </xsl:template>

    <xsl:template match="gpxtpx:hr"><!-- XXX: use qudt-unit#HeartBeatsPerMinute -->
        <td property="qudt-quantity:HeartRate" datatype="xsd:nonNegativeInteger"><xsl:value-of select="normalize-space(.)"/></td>
    </xsl:template>

<!-- From http://wiki.openstreetmap.org/wiki/Slippy_map_tilenames -->
    <xsl:variable name="pi" select="3.14159265358979323846"/>

    <xsl:template name="tiley">
        <xsl:param name="lat"/>
        <xsl:param name="zoomfact"/>
        <xsl:variable name="a" select="($lat * $pi) div 180.0"/>
        <xsl:variable name="b" select="math:log(math:tan($a) + (1.0 div math:cos($a)))"/>
        <xsl:variable name="c" select="(1.0 - ($b div $pi)) div 2.0"/>
        <xsl:value-of select="floor($c * $zoomfact)"/>
    </xsl:template>

    <xsl:template name="tilename">
        <xsl:param name="lat"/>
        <xsl:param name="lon"/>
        <xsl:param name="zoom"/>
        <xsl:variable name="zoomfact" select="math:power(2,$zoom)"/>
        <xsl:variable name="x" select="floor((360.0 + ($lon * 2)) * $zoomfact div 720.0)"/>
        <xsl:variable name="y">
            <xsl:call-template name="tiley">
                <xsl:with-param name="lat" select="$lat"/>
                <xsl:with-param name="zoomfact" select="$zoomfact"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="concat($zoom,'/',$x,'/',$y)"/>
    </xsl:template>
</xsl:stylesheet>
