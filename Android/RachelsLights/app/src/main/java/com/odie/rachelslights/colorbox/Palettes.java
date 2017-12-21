package com.odie.rachelslights.colorbox;

import android.util.Pair;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.odie.rachelslights.R;

class Palettes {

    static final String RED = "RED";
    static final String PINK = "PINK";
    static final String PURPLE = "PURPLE";
    static final String DEEP_PURPLE = "DEEP_PURPLE";
    static final String INDIGO = "INDIGO";
    static final String BLUE = "BLUE";
    static final String LIGHT_BLUE = "LIGHT_BLUE";
    static final String CYAN = "CYAN";
    static final String TEAL = "TEAL";
    static final String GREEN = "GREEN";
    static final String LIGHT_GREEN = "LIGHT_GREEN";
    static final String LIME = "LIME";
    static final String YELLOW = "YELLOW";
    static final String AMBER = "AMBER";
    static final String ORANGE = "ORANGE";
    static final String DEEP_ORANGE = "DEEP_ORANGE";
    static final String BROWN = "BROWN";
    static final String GREY = "GREY";
    static final String BLUE_GREY = "BLUE_GREY";
    private static final String WHITE = "WHITE";
    private static final String BLACK = "BLACK";

    static String[] colorsStrings = new String[]{RED, PINK, PURPLE, DEEP_PURPLE, INDIGO, BLUE, LIGHT_BLUE, CYAN, TEAL, GREEN, LIGHT_GREEN, LIME, YELLOW, AMBER, ORANGE, DEEP_ORANGE, BROWN, GREY, BLUE_GREY, WHITE, BLACK};

    private static String[] codes(boolean codeSet) {

        String[] codesNormal = new String[]{"50", "100", "200", "300", "400", "500", "600", "700", "800", "900", "A100", "A200", "A400", "A700"};

        String[] codesReduced = Arrays.copyOf(codesNormal, codesNormal.length - 4);

        return codeSet ? codesNormal : codesReduced;
    }

    //for cards
    static Pair<String[], String[]> getPalette(String colorSet, Boolean codeSet) {

        Map<String, String[]> colors = new HashMap<>();

        colors.put(RED, new String[]{"#FFEBEE", "#FFCDD2", "#EF9A9A", "#E57373", "#EF5350", "#F44336", "#E53935", "#D32F2F", "#C62828", "#B71C1C", "#FF8A80", "#FF5252", "#FF1744", "#D50000"});
        colors.put(PINK, new String[]{"#FCE4EC", "#F8BBD0", "#F48FB1", "#F06292", "#EC407A", "#E91E63", "#D81B60", "#C2185B", "#AD1457", "#880E4F", "#FF80AB", "#FF4081", "#F50057", "#C51162"});
        colors.put(PURPLE, new String[]{"#F3E5F5", "#E1BEE7", "#CE93D8", "#BA68C8", "#AB47BC", "#9C27B0", "#8E24AA", "#7B1FA2", "#6A1B9A", "#4A148C", "#EA80FC", "#E040FB", "#D500F9", "#AA00FF"});
        colors.put(DEEP_PURPLE, new String[]{"#EDE7F6", "#D1C4E9", "#B39DDB", "#9575CD", "#7E57C2", "#673AB7", "#5E35B1", "#512DA8", "#4527A0", "#311B92", "#B388FF", "#7C4DFF", "#651FFF", "#6200EA"});
        colors.put(INDIGO, new String[]{"#E8EAF6", "#C5CAE9", "#9FA8DA", "#7986CB", "#5C6BC0", "#3F51B5", "#3949AB", "#303F9F", "#283593", "#1A237E", "#8C9EFF", "#536DFE", "#3D5AFE", "#304FFE"});
        colors.put(BLUE, new String[]{"#E3F2FD", "#BBDEFB", "#90CAF9", "#64B5F6", "#42A5F5", "#2196F3", "#1E88E5", "#1976D2", "#1565C0", "#0D47A1", "#82B1FF", "#448AFF", "#2979FF", "#2962FF"});
        colors.put(LIGHT_BLUE, new String[]{"#E1F5FE", "#B3E5FC", "#81D4FA", "#4FC3F7", "#29B6F6", "#03A9F4", "#039BE5", "#0288D1", "#0277BD", "#01579B", "#80D8FF", "#40C4FF", "#00B0FF", "#0091EA"});
        colors.put(CYAN, new String[]{"#E0F7FA", "#B2EBF2", "#80DEEA", "#4DD0E1", "#26C6DA", "#00BCD4", "#00ACC1", "#0097A7", "#00838F", "#006064", "#84FFFF", "#18FFFF", "#00E5FF", "#00B8D4"});
        colors.put(TEAL, new String[]{"#E0F2F1", "#B2DFDB", "#80CBC4", "#4DB6AC", "#26A69A", "#009688", "#00897B", "#00796B", "#00695C", "#004D40", "#A7FFEB", "#64FFDA", "#1DE9B6", "#00BFA5"});
        colors.put(GREEN, new String[]{"#E8F5E9", "#C8E6C9", "#A5D6A7", "#81C784", "#66BB6A", "#4CAF50", "#43A047", "#388E3C", "#2E7D32", "#1B5E20", "#B9F6CA", "#69F0AE", "#00E676", "#00C853"});
        colors.put(LIGHT_GREEN, new String[]{"#F1F8E9", "#DCEDC8", "#C5E1A5", "#AED581", "#9CCC65", "#8BC34A", "#7CB342", "#689F38", "#558B2F", "#33691E", "#33691E", "#B2FF59", "#76FF03", "#64DD17"});
        colors.put(LIME, new String[]{"#F9FBE7", "#F0F4C3", "#E6EE9C", "#DCE775", "#D4E157", "#CDDC39", "#C0CA33", "#AFB42B", "#9E9D24", "#827717", "#F4FF81", "#EEFF41", "#C6FF00", "#AEEA00"});
        colors.put(YELLOW, new String[]{"#FFFDE7", "#FFF9C4", "#FFF59D", "#FFF176", "#FFEE58", "#FFEB3B", "#FDD835", "#FBC02D", "#F9A825", "#F57F17", "#FFFF8D", "#FFFF00", "#FFEA00", "#FFD600"});
        colors.put(AMBER, new String[]{"#FFF8E1", "#FFECB3", "#FFE082", "#FFD54F", "#FFCA28", "#FFC107", "#FFB300", "#FFA000", "#FF8F00", "#FF6F00", "#FFE57F", "#FFD740", "#FFC400", "#FFAB00"});
        colors.put(ORANGE, new String[]{"#FFF3E0", "#FFE0B2", "#FFCC80", "#FFB74D", "#FFA726", "#FF9800", "#FB8C00", "#F57C00", "#EF6C00", "#E65100", "#FFD180", "#FFAB40", "#FF9100", "#FF6D00"});
        colors.put(DEEP_ORANGE, new String[]{"#FBE9E7", "#FFCCBC", "#FFAB91", "#FF8A65", "#FF7043", "#FF5722", "#F4511E", "#E64A19", "#D84315", "#BF360C", "#FF9E80", "#FF6E40", "#FF3D00", "#DD2C00"});
        colors.put(BROWN, new String[]{"#EFEBE9", "#D7CCC8", "#BCAAA4", "#A1887F", "#8D6E63", "#795548", "#6D4C41", "#5D4037", "#4E342E", "#4E342E"});
        colors.put(GREY, new String[]{"#FAFAFA", "#F5F5F5", "#EEEEEE", "#E0E0E0", "#BDBDBD", "#9E9E9E", "#757575", "#616161", "#424242", "#212121"});
        colors.put(BLUE_GREY, new String[]{"#ECEFF1", "#CFD8DC", "#B0BEC5", "#90A4AE", "#78909C", "#78909C", "#78909C", "#455A64", "#37474F", "#263238"});

        colors.put(WHITE, new String[]{"#FFFFFF"});
        colors.put(BLACK, new String[]{"#000000"});

        return new Pair<>(codes(codeSet), colors.get(colorSet));
    }

    //for circles
    static String[] getSelectorColors() {

        List<String> colors = new ArrayList<>();

        for (int j = 0; j < colorsStrings.length - 2; j++) {

            colors.add(getPalette(colorsStrings[j], true).second[5]);
        }

        colors.add("#FFFFFF");
        colors.add("#000000");
        return colors.toArray(new String[colors.size()]);
    }
}
