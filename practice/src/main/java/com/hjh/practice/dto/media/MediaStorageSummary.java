package com.hjh.practice.dto.media;

import java.util.Locale;

public class MediaStorageSummary {

    private final long totalSpaceBytes;
    private final long usedSpaceBytes;
    private final int usagePercent;

    public MediaStorageSummary(long totalSpaceBytes, long usedSpaceBytes) {
        this.totalSpaceBytes = totalSpaceBytes;
        this.usedSpaceBytes = usedSpaceBytes;
        this.usagePercent = totalSpaceBytes <= 0
                ? 0
                : (int) Math.min(100, Math.round(usedSpaceBytes * 100.0 / totalSpaceBytes));
    }

    public String getTotalSpaceDisplay() {
        return formatBytes(totalSpaceBytes);
    }

    public String getUsedSpaceDisplay() {
        return formatBytes(usedSpaceBytes);
    }

    public int getUsagePercent() {
        return usagePercent;
    }

    private String formatBytes(long bytes) {
        if (bytes < 1024) {
            return bytes + " B";
        }

        String[] units = {"KB", "MB", "GB", "TB"};
        double value = bytes;
        int unitIndex = -1;
        do {
            value /= 1024.0;
            unitIndex++;
        } while (value >= 1024 && unitIndex < units.length - 1);

        return String.format(Locale.ROOT, "%.1f %s", value, units[unitIndex]);
    }
}
