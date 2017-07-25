replaceURL() {
MATCH=$1;
REPLACE=$2;
sed -i 's/'"$MATCH"'/'"$REPLACE"'/g' pom.xml releng/*.parent/pom.xml releng/*.updatesite.aggregated/updatesite.aggr;
}
replaceURL 'download.eclipse.org\/releases\/oxygen' 'sdqbuild.ipd.kit.edu\/nexus\/content\/groups\/eclipse-oxygen-complete';
replaceURL 'sdqweb.ipd.kit.edu\/eclipse\/palladiosimulator\/nightly\/aggregate' 'sdqbuild.ipd.kit.edu\/nexus\/content\/repositories\/palladiosimulator-nightly';
replaceURL 'sdqweb.ipd.kit.edu\/eclipse\/palladiosimulator\/nightly' 'sdqbuild.ipd.kit.edu\/nexus\/content\/repositories\/palladiosimulator-nightly';
replaceURL 'sdqweb.ipd.kit.edu\/eclipse\/emf-profiles-updatesite' 'sdqbuild.ipd.kit.edu\/nexus\/content\/repositories\/emf-profiles';
replaceURL 'kit-sdq.github.io\/updatesite\/nightly' 'sdqbuild.ipd.kit.edu\/nexus\/content\/repositories\/kit-sdq-nightly';
replaceURL 'kastel-scbs.github.io\/updatesite\/nightly' 'sdqbuild.ipd.kit.edu\/nexus\/content\/repositories\/kastel-scbs';
# git add releng/*.updatesite.aggregated/updatesite.aggr;
# git add pom.xml
# git add releng/*.parent/pom.xml;
# git commit -m "replace references to update sites with SDQ Nexus mirrors";