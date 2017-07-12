# This script can be used to make an Eclipse plug-in project ready to be build with maven tycho.
# It creates and initializes all pom.xml fiels and an extensions.xml files.
#
# usage: 
# ------
# ./maventychonize.sh groupIDPrefix plugInName
#     where groupdIDPrefix is usually of the form 'tld.domain.subdomain.whatever'
#     and plugInName is usually of the form 'someShortName'
#
# prequisites:
# ------------
# You need to have
#    a plug-in project named '<groupIDPrefix>.<plugInName>'
#    stored in a folder named 'bundles', 
#    a plug-in project with JUnit tests named '<groupIDPrefix>.<plugInName>.tests'
#    stored in a folder named 'tests',
#    a feature project named '<groupIDPrefix>.<plugInName>.feature'
#    stored in a folder named 'releng', and
#    an update site project named '<groupIDPrefix>.<plugInName>.updatesite'
#    stored in the same folder 'releng'.
#
# follow-up:
# ----------
# You have to 
#    change the explicit dependencies to features of other update sites in the
#       relend/...updatesite.aggregated/updatesite.aggr file.
#
# If you have more than one Eclipse plug-in to be included in the build or
# if your build depends on other update sites, then you have to 
#    add your plug-ins to the 
#       releng/...aggregator/pom.xml file and 
#    add the update sites to the
#       releng/...parent/pom.xml file, where we already put TODO comments for you.
#
# Furthermore, you may want to 
#    add a description, copyright, and license text to the 
#        features/.../feature.xml file and 
#    add a category description for the update site to the
#        releng/...updatesite/category.xml file, where we also already put TODO comments for you.
#
#####################################################################
# input:
GROUPIDPREFIX=$1;
PLUGINNAME=$2;
GROUPID=$GROUPIDPREFIX.$PLUGINNAME;
# bundles/
BUNDLESFOLDER=bundles;
BUNDLESPOM=$BUNDLESFOLDER/pom.xml;
# features/
FEATURESFOLDER=features;
FEATURESPOM=$FEATUREFOLDER/pom.xml;
FEATUREFOLDER=features/$GROUPID.feature;
FEATUREPROJECT=$FEATUREFOLDER/.project;
FEATUREBUILDPROPS=$FEATUREFOLDER/build.properties;
FEATUREXML=$FEATUREFOLDER/feature.xml;
# .
MAINPOM=pom.xml;
# releng/
AGGREGATORFOLDER=releng/$GROUPID.aggregator;
AGGREGATORPOM=$AGGREGATORFOLDER/pom.xml;
PARENTFOLDER=releng/$GROUPID.parent;
PARENTPOM=$PARENTFOLDER/pom.xml;
UPDATESITEFOLDER=releng/$GROUPID.updatesite;
UPDATESITEPROJECT=$UPDATESITEFOLDER/.project;
UPDATESITECATEGORY=$UPDATESITEFOLDER/category.xml;
UPDATESITEPOM=$UPDATESITEFOLDER/pom.xml
UPDATESITEAGGRFOLDER=$UPDATESITEFOLDER.aggregated;
UPDATESITEAGGRPROJECT=$UPDATESITEAGGRFOLDER/.project;
UPDATESITEAGGR=$UPDATESITEAGGRFOLDER/updatesite.aggr;
UPDATESITEAGGRPOM=$UPDATESITEAGGRFOLDER/pom.xml
#####################################################################
# bundles/
cp bundle_TEMPLATE.pom $BUNDLESPOM;
sed -i 's/thePlugInName/'$PLUGINNAME'/g' $BUNDLESPOM;
sed -i 's/theGroupID/'$GROUPID'/g' $BUNDLESPOM;
# features/
mkdir -P $FEATUREFOLDER;
cp feature_TEMPLATE.project $FEATUREPROJECT;
sed -i 's/theGroupID/'$GROUPID'/g' $FEATUREPROJECT;
cp feature_build_TEMPLATE.properties $FEATUREBUILDPROPS;
cp feature_TEMPLATE.xml $FEATUREXML;
sed -i 's/thePlugInName/'$PLUGINNAME'/g' $FEATUREXML;
sed -i 's/theGroupID/'$GROUPID'/g' $FEATUREXML;
cp features_TEMPLATE.pom $FEATURESPOM;
sed -i 's/thePlugInName/'$PLUGINNAME'/g' $FEATURESPOM;
sed -i 's/theGroupID/'$GROUPID'/g' $FEATURESPOM;
# .mvn/
mkdir .mvn;
cp extensions.xml .mvn/;
# .
cp main_TEMPLATE.pom $MAINPOM;
sed -i 's/theGroupID/'$GROUPID'/g' $MAINPOM;
# releng/...aggregator
mkdir -P $AGGREGATORFOLDER;
cp aggregator_TEMPLATE.pom $AGGREGATORPOM;
sed -i 's/theGroupID/'$GROUPID'/g' $AGGREGATORPOM;
# releng/...parent
mkdir $PARENTFOLDER;
cp parent_TEMPLATE.pom $PARENTPOM;
sed -i 's/theGroupID/'$GROUPID'/g' $PARENTPOM;
# releng/...updatesite
mkdir $UPDATESITEFOLDER;
cp updatesite_TEMPLATE.project $UPDATESITEPROJECT;
sed -i 's/theGroupID/'$GROUPID'/g' $UPDATESITEPROJECT;
cp category_TEMPLATE.xml $UPDATESITECATEGORY;
sed -i 's/thePlugInName/'$PLUGINNAME'/g' $UPDATESITECATEGORY;
sed -i 's/theGroupID/'$GROUPID'/g' $UPDATESITECATEGORY;
cp updatesite_TEMPLATE.pom $UPDATESITEPOM;
sed -i 's/thePlugInName/'$PLUGINNAME'/g' $UPDATESITEPOM;
sed -i 's/theGroupID/'$GROUPID'/g' $UPDATESITEPOM;
# releng/...updatesite
mkdir $UPDATESITEAGGRFOLDER;
cp updatesiteaggregated_TEMPLATE.project $UPDATESITEAGGRPROJECT;
sed -i 's/theGroupID/'$GROUPID'/g' $UPDATESITEAGGRPROJECT;
cp updatesiteaggregated_TEMPLATE.aggr $UPDATESITEAGGR;
sed -i 's/thePlugInName/'$PLUGINNAME'/g' $UPDATESITEAGGR;
sed -i 's/theGroupID/'$GROUPID'/g' $UPDATESITEAGGR;
cp updatesiteaggregated_TEMPLATE.pom $UPDATESITEAGGRPOM;
sed -i 's/thePlugInName/'$PLUGINNAME'/g' $UPDATESITEAGGRPOM;
sed -i 's/theGroupID/'$GROUPID'/g' $UPDATESITEAGGRPOM;
#####################################################################