using System.Collections.Generic;

namespace OurFoodituteApp.DataBase
{
    public partial class AutocompleteReference
    {
        private List<string> ECODES = new List<string>
        {
            "100","101","101a","102","103","104","105","106","107","110","111","120","121","122","123","124","125","126","127","128","129","130","131","132","133","140",
            "141","142","143","150a","150b","150c","150d","151","153","154","155","160a","160b","160c","160d","160e","160f","161b","161g","162","163","170","171","172",
            "173","174","175","180","181","200","201","202","203","210","211","212","213","214","215","216","217","218","219","220","221","222","223","224","226","227",
            "228","230","231","232","233","234","235","236","237","238","239","242","249","250","251","252","260","261","262","263","264","270","280","281","282","283",
            "284","285","290","296","297","300","301","302","303","304","306","307","308","309","310","311","312","315","316","317","318","319","320","321","322","325",
            "326","327","328","329","330","331","332","333","334","335","336","337","338","339","340","341","343","350","351","352","353","354","355","356","357","363",
            "370","375","380","381","385","400","401","402","403","404","405","406","407","407a","410","412","413","414","415","416","417","418","420","421","422","425",
            "430","431","432","433","434","435","436","440","441","442","444","445","450","451","452","459","460","461","463","464","465","466","467","468","469","470a",
            "470b","471","472a","472b","472c","472d","472e","472f","473","474","475","476","477","478","479b","480","481","482","483","491","492","493","494","495","500",
            "501","503","504","507","508","509","510","511","512","513","514","515","516","517","518","519","520","521","522","523","524","525","526","527","528","529",
            "530","535","536","538","540","541","542","544","545","551","552","553a","553b","554","555","556","558","559","570","574","575","576","577","578","579","585",
            "620","621","622","623","624","625","626","627","628","629","630","631","632","633","634","635","636","637","640","650","710","713","900","901","902","903","904",
            "905","907","912","913","914","920","921","924","925","926","927b","928","931","932","938","939","941","942","943a","943b","944","948","949","950","951","952",
            "953","954","955","957","959","965","966","967","999","1100","1103","1105","1200","1201","1202","1404","1410","1412","1413","1414","1420","1422","1440","1442",
            "1450","1451","1505","1510","1518","1520","Curcuma (turmeric)","Riboflavin (Vitamin B2)","Riboflavin-5'-Phosphate","Tartrazine (FD&C Yellow 5)",
            "Chrysoine resorcinol","Quinoline Yellow","Fast Yellow AB","Riboflavin-5-Sodium Phosphate","Yellow 2G","Sunset Yellow FCF (Orange Yellow S)","Orange GGN",
            "Cochineal; Carminic acid; Carmines","Citrus Red 2","Carmoisine; Azorubine","Amaranth; FD&C Red 2","Ponceau 4R; Cochineal Red A, Brilliant Scarlet 4R",
            "Ponceau SX; Scarlet GN","Ponceau 6R","Erythrosine (FD&C Red 3)","Red 2G","Allura Red AC (FD&C Red 40)","Indanthrene blue RS","Patent Blue V",
            "Indigo carmine; FD&C Blue 2","Brilliant Blue FCF (FD&C Blue 1)","Chlorophylls and chlorophyllins","Copper complexes of chlorophylls and chlorophyllins",
            "Green S","Fast Green FCF (FD&C Green 3)","Plain caramel","Caustic sulphite caramel","Ammonia caramel","Sulphite ammonia caramel","Black PN; Brilliant Black BN",
            "Vegetable carbon","Brown FK","Brown HT","Carotenes","Annatto; Bixin; Norbixin","Paprika extract; Capsanthian; Capsorubin","Lycopene","Beta-apo-8' carotenal (C30)",
            "Ethyl ester of beta-apo-8'-carotenic acid (C 30)","Lutein","Canthaxanthin","Beetroot Red; Betanin","Anthocyanins","Calcium carbonate","Titanium dioxide",
            "Iron oxides and hydroxides","Aluminium","Silver","Gold","Pigment Rubine; Lithol Rubine BK","Tannin","Sorbic acid","Sodium sorbate","Potassium sorbate",
            "Calcium sorbate","Benzoic acid","Sodium benzoate","Potassium benzoate","Calcium benzoate","Ethyl p-hydroxybenzoate","Sodium ethyl p-hydroxybenzoate",
            "Propyl p-hydroxybenzoate","Sodium propyl p-hydroxybenzoate","Methyl p-hydroxybenzoate","Sodium methyl p-hydroxybenzoate","Sulphur dioxide","Sodium sulphite",
            "Sodium hydrogen sulphite","Sodium metabisuiphite","Potassium metabisulphite","Calcium sulphite","Calcium hydrogen sulphite","Potassium hydrogen sulphite",
            "Biphenyl; diphenyl","Orthophenyl phenol","Sodium orthophenyl phenol","Thiabendazole","Nisin","Natamycin","Formic acid","Sodium formate","Calcium formate",
            "Hexamethylene tetramine","Dimethyl dicarbonate","Potassium nitrite","Sodium nitrite","Sodium nitrate","Potassium nitrate","Acetic acid","Potassium acetate",
            "Sodium acetate; Sodium diacetate","Calcium acetate","Ammonium acetate","Lactic acid","Propionic acid","Sodium propionate","Calcium propionate",
            "Potassium propionate","Boric acid","Sodium tetraborate; borax","Carbon dioxide","Malic acid","Fumaric acid","Ascorbic acid","Sodium ascorbate","Calcium ascorbate",
            "Potassium ascorbate","Fatty acid esters of ascorbic acid","Tocopherols","Alpha-tocopherol","Gamma-tocopherol","Delta-tocopherol","Propyl gallate","Octyl gallate",
            "Dodecyl gallate","Erythorbic acid","Sodium erythorbate","Erythorbic acid","Sodium erythorbate","Tert-ButylHydroQuinone(TBHQ)","Butylated hydroxyanisole(BHA)",
            "Butylated hydroxytoluene(BHT)","Lecithins","Sodium lactate","Potassium lactate","Calcium lactate","Ammonium lactate","Magnesium lactate","Citric acid",
            "Sodium citrates","Potassium citrates","Calcium citrates","Tartaric acid","Sodium tartrates","Potassium tartrates","Sodium potassium tartrate","Phosphoric acid",
            "Sodium phosphates","Potassium phosphates","Calcium phosphates","Magnesium phosphates","Sodium malates","Potassium malate","Calcium malate","Metatartaric acid",
            "Calcium tartrate","Adipic acid","Sodium adipate","Potassium adipate","Succinic acid","Heptonolactone","Niacin","Triammonium citrate","Ammonium ferric citrates",
            "Calcium disodium EDTA","Alginic acid","Sodium alginate","Potassium alginate","Ammonium alginate","Calcium alginate","Propane-1,2-diol alginate","Agar","Carrageenan",
            "Processed eucheuma seaweed","Locust bean gum; carob gum","Guar gum","Tragacanth","Acacia gum; gum arabic","Xanthan gum","Karaya gum","Tara gum","Gellan gum",
            "Sorbitol; Sorbitol syrup","Mannitol","Glycerol","Konjac","Polyoxyethylene stearate","Polyoxyethylene(40) stearate","Polysorbate 20","Polysorbate 80",
            "Polysorbate 40","Polysorbate 60","Polysorbate 65","Pectins","Gelatine","Ammonium phosphatides","Sucrose acetate isobutyrate","Glycerol esters of wood rosins",
            "Diphosphates","Triphosphates","Polyphosphates","Beta-cyclodextrin","Cellulose","Methyl cellulose","Hydroxypropyl cellulose","Hydroxypropyl methyl cellulose",
            "Ethyl methyl cellulose","Carboxy methyl cellulose","Sodium carboxy methyl cellulose","Croscarmellose","Sodium caseinate","Fatty acids salts",
            "Magnesium salts of fatty acids", "Mono- and diglycerides of fatty acids","Fatty acid esters of glycerol","Lactic acid esters of mono- and diglycerides of fatty acids",
            "Citric acid esters of mono- and diglycerides of fatty acids","Tartaric acid esters of mono- and diglycerides of fatty acids",
            "Mono- and diacetyltartaric acid esters of mono- and diglycerides of fatty acids","Mixed acetic and tartaric acid esters of mono- and diglycerides of fatty acids",
            "Sucrose esters of fatty acids","Sucroglycerides","Polyglycerol esters of fatty acids","Polyglycerol polyricinoleate","Propylene glycol esters of fatty acids",
            "Lactylated fatty acid esters of glycerol and propane","Thermally oxidised soya bean oil interacted with mono and diglycerides of fatty acids",
            "Dioctyl sodium sulphosuccinate","Sodium stearoyl-2-lactylate","Calcium stearoyl-2-lactylate","Stearyl tartrate","Sorbitan monostearate","Sorbitan tristearate",
            "Sorbitan monolaurate","Sorbitan monooleate","Sorbitan monopalmitate Sorbitan monopalmitate","Sodium carbonates","Potassium carbonate","Ammonium carbonate",
            "Magnesium carbonate","Hydrochloric acid","Potassium chloride","Calcium chloride","Ammonium chloride","Magnesium chloride","Stannous chloride","Sulfuric acid",
            "Sodium sulfate","Potassium sulfate","Calcium sulfate","Ammonium sulfate","Magnesium sulphate","Copper sulphate","Aluminium sulphate","Aluminium sodium sulfate",
            "Aluminium potassium sulfate","Aluminium ammonium sulfate","Sodium hydroxide","Potassium hydroxide","Calcium hydroxide","Ammonium hydroxide","Magnesium hydroxide",
            "Calcium oxide","Magnesium oxide","Sodium ferrocyanide","Potassium ferrocyanide","Calcium ferrocyanide","Dicalcium diphosphate","Sodium aluminium phosphate",
            "Bone phosphate","Calcium polyphosphates","Ammonium polyphosphates","Silicon dioxide","Calcium silicate","Magnesiumsilicate","Talc","Sodium aluminium silicate",
            "Potassium aluminium silicate","Aluminium calcium silicate","Bentonite","Aluminium silicate, kaolin","Fatty acids","Gluconic acid","Glucono delta lactone",
            "Sodium gluconate","Potassium gluconate","Calcium gluconate","Ferrous gluconate","Ferrous lactate","Glutamic acid","Monosodium glutamate","Monopotassium glutamate",
            "Calcium diglutamate","Monoammonium glutamate","Magnesium diglutamate","Guanylic acid","Disodium guanylate","Dipotassium guanylate","Calcium guanylate","Inosinic acid",
            "Disodium inosinate","Dipotassium inosinate","Calcium inosinate","Calcium 5'-ribonucleotides","Disodium 5'-ribonucleotides","Maltol","Ethyl maltol",
            "Glycine and its sodium salt","Zinc acetate","Spiramycins","Tylosin","Dimethylpolysiloxane","Beeswax","Candelilla wax","Carnauba wax","Shellac","Microcrystalline wax",
            "Refined microcrystalline wax","Montan acid esters","Lanolin","Oxidised polyethylene wax","L-cysteine","L-Cystin","Potassium bromate","Chlorine","Chlorine dioxide",
            "Carbamide","Benzoyl peroxide","Nitrogen","Nitrous oxide","Argon","Helium","Nitrogen","Nitrous oxide","Butane","Iso-butane","Propane","Oxygen","Hydrogen",
            "Acesulphane potassium","Aspartame","Cyclamic acid and its Na and Ca salts","lsomalt","Saccharin and its Na, K and Ca salts","Sucralose","Thaumatin","Neohesperidine DC",
            "Maltitol; Maltitol syrup","Lactitol","Xylitol","Quillaia extract","Amylase","Invertase","Lysozyme","Polydextrose","Polyvinylpyrrolidone","Polyvinylpolypyrrolidone",
            "Oxidised starch","Monostarch phosphate","Distarch phosphate","Phosphated distarch phosphate","Acetylated distarch phosphate","Acetylated starch",
            "Acetylated distarch adipate","Hydroxyl propyl starch","Hydroxyl propyl distarch phosphate","Starch sodium octenyl succinate","Acetylated oxidised starch",
            "Triethyl citrate","Ethanol","Glyceryl triacetate, triacetin","Propylene glycol"
        };

        public List<string> ReturnList() { 
            return ECODES;
        }
    }
}

