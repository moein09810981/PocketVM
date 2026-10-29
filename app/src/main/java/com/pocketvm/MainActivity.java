
package com.pocketvm;

import android.app.Activity;
import android.os.Bundle;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import android.view.Gravity;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.SeekBar;
import android.widget.Toast;

public class MainActivity extends Activity {

    final int BG = Color.rgb(10, 12, 15);
    final int CARD = Color.rgb(20, 23, 28);
    final int ORANGE = Color.rgb(255, 100, 15);
    final int WHITE = Color.rgb(245, 246, 248);
    final int MUTED = Color.rgb(145, 151, 162);
    final int GREEN = Color.rgb(43, 211, 133);

    LinearLayout content;
    TextView homeTab, machinesTab, downloadsTab, settingsTab;
    String selectedOs = "Alpine Linux";
    int ramValue = 12;
    int cpuValue = 2;
    int diskValue = 8;
    String downloadFilter = "همه";

    @Override
    protected void onCreate(Bundle state) {
        super.onCreate(state);

        getWindow().setStatusBarColor(BG);
        getWindow().setNavigationBarColor(BG);

        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setBackgroundColor(BG);
        root.setLayoutDirection(View.LAYOUT_DIRECTION_RTL);

        ScrollView scroll = new ScrollView(this);
        scroll.setFillViewport(true);

        content = new LinearLayout(this);
        content.setOrientation(LinearLayout.VERTICAL);
        content.setPadding(dp(20), dp(20), dp(20), dp(24));
        content.setLayoutDirection(View.LAYOUT_DIRECTION_RTL);

        scroll.addView(content);
        root.addView(scroll, new LinearLayout.LayoutParams(-1, 0, 1));

        root.addView(createNavigation());
        setContentView(root);

        showHome();
    }

    void showHome() {
        setSelectedTab("خانه");
        content.removeAllViews();

        LinearLayout header = new LinearLayout(this);
        header.setGravity(Gravity.CENTER_VERTICAL);

        LinearLayout logo = new LinearLayout(this);
        logo.setGravity(Gravity.CENTER);
        logo.setBackground(round(ORANGE, 15));
        TextView mark = text("P", 25, Color.BLACK, true);
        logo.addView(mark);
        header.addView(logo, params(48, 48));

        LinearLayout brand = new LinearLayout(this);
        brand.setOrientation(LinearLayout.VERTICAL);
        brand.setPadding(dp(12), 0, 0, 0);
        brand.addView(text("PocketVM", 22, WHITE, true));
        brand.addView(text("YOUR VM, YOUR CONTROL", 9, MUTED, true));
        header.addView(brand, new LinearLayout.LayoutParams(0, -2, 1));

        TextView settings = text("⚙", 25, WHITE, false);
        settings.setGravity(Gravity.CENTER);
        settings.setOnClickListener(v -> showSettings());
        header.addView(settings, params(44, 44));

        content.addView(header);

        space(20);
        content.addView(text("ماشین‌های مجازی تو", 24, WHITE, true));
        space(5);
        content.addView(text("سیستم‌عاملت رو انتخاب کن و اجرا کن.", 13, MUTED, false));

        space(22);
        content.addView(createFeaturedCard());
        space(2);
        LinearLayout dots = new LinearLayout(this);
        dots.setGravity(Gravity.CENTER);
        for (int i = 0; i < 4; i++) {
            TextView dot = text("●", 8, i == 0 ? ORANGE : Color.rgb(57, 63, 72), true);
            dot.setGravity(Gravity.CENTER);
            dots.addView(dot, params(14, 18));
        }
        content.addView(dots);

        space(12);

        LinearLayout titleRow = new LinearLayout(this);
        titleRow.setGravity(Gravity.CENTER_VERTICAL);
        titleRow.addView(text("ماشین‌های من", 18, WHITE, true),
                new LinearLayout.LayoutParams(0, -2, 1));

        TextView add = text("+ افزودن", 13, ORANGE, true);
        add.setOnClickListener(v -> showCreate());
        titleRow.addView(add);
        content.addView(titleRow);

        space(12);
        content.addView(createMachineRow(
                "Linux", "Alpine Linux ARM64", "QEMU متصل نیست", "◈"));
        space(10);

        LinearLayout empty = new LinearLayout(this);
        empty.setGravity(Gravity.CENTER);
        empty.setPadding(dp(12), dp(14), dp(12), dp(14));
        empty.setBackground(round(CARD, 16));
        empty.addView(text("＋  ماشین‌های دیگر را بعداً اضافه کن",
                12, MUTED, false));
        content.addView(empty);

        space(24);
        content.addView(text("فضای ذخیره‌سازی", 15, WHITE, true));
        space(10);

        LinearLayout storage = panel();
        storage.setOrientation(LinearLayout.VERTICAL);
        storage.setPadding(dp(15), dp(15), dp(15), dp(15));

        LinearLayout storageRow = new LinearLayout(this);
        storageRow.setGravity(Gravity.CENTER_VERTICAL);
        storageRow.addView(text("▤  فضای ماشین‌ها", 13, WHITE, false),
                new LinearLayout.LayoutParams(0, -2, 1));
        storageRow.addView(text("هنوز خالی", 12, MUTED, false));
        storage.addView(storageRow);

        spaceIn(storage, 14);
        View barBg = new View(this);
        barBg.setBackground(round(Color.rgb(43, 47, 54), 10));
        storage.addView(barBg, new LinearLayout.LayoutParams(-1, dp(6)));

        content.addView(storage);
    }

    View createFeaturedCard() {
        LinearLayout card = new LinearLayout(this);
        card.setOrientation(LinearLayout.VERTICAL);
        card.setPadding(dp(18), dp(18), dp(18), dp(18));
        card.setBackground(roundGradient(
                new int[]{Color.rgb(47, 29, 20), Color.rgb(17, 20, 25)}, 22));
        card.setElevation(dp(3));

        LinearLayout status = new LinearLayout(this);
        status.setGravity(Gravity.CENTER_VERTICAL);
        TextView dot = text("●", 11, GREEN, true);
        status.addView(dot);
        status.addView(text("  نمایشی · موتور اجرا متصل نیست", 11, MUTED, true));
        card.addView(status);

        spaceIn(card, 20);
        LinearLayout linuxHero = new LinearLayout(this);
        linuxHero.setGravity(Gravity.CENTER_VERTICAL);
        LinearLayout linuxText = new LinearLayout(this);
        linuxText.setOrientation(LinearLayout.VERTICAL);
        linuxText.addView(text("Linux", 26, WHITE, true));
        spaceIn(linuxText, 4);
        linuxText.addView(text("Alpine Linux 3.20 (ARM64)", 12, MUTED, false));
        linuxHero.addView(linuxText, new LinearLayout.LayoutParams(0, -2, 1));
        TextView penguin = text("🐧", 44, WHITE, true);
        penguin.setGravity(Gravity.CENTER);
        linuxHero.addView(penguin, params(64, 68));
        card.addView(linuxHero);

        spaceIn(card, 22);

        LinearLayout specs = new LinearLayout(this);
        specs.addView(text("▣  1.2 GB RAM", 11, WHITE, false),
                new LinearLayout.LayoutParams(0, -2, 1));
        specs.addView(text("⚙  2 vCPU", 11, WHITE, false),
                new LinearLayout.LayoutParams(0, -2, 1));
        specs.addView(text("▤  8 GB دیسک", 11, WHITE, false),
                new LinearLayout.LayoutParams(0, -2, 1));
        card.addView(specs);

        spaceIn(card, 22);

        TextView run = text("اجرا    ▶", 16, Color.BLACK, true);
        run.setGravity(Gravity.CENTER);
        run.setBackground(round(ORANGE, 15));
        run.setPadding(dp(12), dp(16), dp(12), dp(16));
        run.setOnClickListener(v -> Toast.makeText(this,
                "موتور QEMU هنوز به برنامه متصل نشده است.",
                Toast.LENGTH_LONG).show());
        card.addView(run);

        return card;
    }

    View createMachineRow(String name, String description,
                          String status, String symbol) {
        LinearLayout row = panel();
        row.setGravity(Gravity.CENTER_VERTICAL);
        row.setPadding(dp(14), dp(14), dp(14), dp(14));

        TextView icon = text(symbol, 25, ORANGE, true);
        icon.setGravity(Gravity.CENTER);
        icon.setBackground(round(Color.rgb(49, 32, 24), 14));
        row.addView(icon, params(48, 48));

        LinearLayout info = new LinearLayout(this);
        info.setOrientation(LinearLayout.VERTICAL);
        info.setPadding(dp(12), 0, 0, 0);
        info.addView(text(name, 15, WHITE, true));
        spaceIn(info, 4);
        info.addView(text(description, 11, MUTED, false));
        row.addView(info, new LinearLayout.LayoutParams(0, -2, 1));

        TextView badge = text("● " + status, 10, GREEN, true);
        row.addView(badge);

        return row;
    }

    View stat(String title, String value, String subtitle) {
        LinearLayout box = panel();
        box.setOrientation(LinearLayout.VERTICAL);
        box.setPadding(dp(12), dp(13), dp(12), dp(12));
        box.addView(text(title, 12, MUTED, false));
        spaceIn(box, 7);
        box.addView(text(value, 21, WHITE, true));
        spaceIn(box, 3);
        box.addView(text(subtitle, 10, MUTED, false));
        return box;
    }

    View createNavigation() {
        LinearLayout nav = new LinearLayout(this);
        nav.setGravity(Gravity.CENTER);
        nav.setPadding(dp(8), dp(8), dp(8), dp(8));
        nav.setBackground(round(Color.rgb(17, 19, 23), 20));

        homeTab = navItem("⌂", "خانه", true);
        machinesTab = navItem("▣", "ماشین‌ها", false);
        downloadsTab = navItem("↓", "دانلودها", false);
        settingsTab = navItem("⚙", "تنظیمات", false);

        nav.addView(homeTab, new LinearLayout.LayoutParams(0, dp(55), 1));
        nav.addView(machinesTab, new LinearLayout.LayoutParams(0, dp(55), 1));
        nav.addView(downloadsTab, new LinearLayout.LayoutParams(0, dp(55), 1));
        nav.addView(settingsTab, new LinearLayout.LayoutParams(0, dp(55), 1));

        return nav;
    }

    void setSelectedTab(String selectedLabel) {
        setNavItemState(homeTab, "خانه", selectedLabel);
        setNavItemState(machinesTab, "ماشین‌ها", selectedLabel);
        setNavItemState(downloadsTab, "دانلودها", selectedLabel);
        setNavItemState(settingsTab, "تنظیمات", selectedLabel);
    }

    void setNavItemState(TextView item, String label, String selectedLabel) {
        if (item == null) return;
        boolean selected = label.equals(selectedLabel);
        item.setTextColor(selected ? ORANGE : MUTED);
        item.setTypeface(Typeface.DEFAULT, selected ? Typeface.BOLD : Typeface.NORMAL);
        item.setBackground(selected
                ? round(Color.rgb(42, 29, 23), 14)
                : round(Color.TRANSPARENT, 14));
    }

    TextView navItem(String icon, String label, boolean selected) {
        TextView item = text(icon + "\n" + label, 12,
                selected ? ORANGE : MUTED, selected);
        item.setGravity(Gravity.CENTER);
        item.setPadding(dp(4), dp(4), dp(4), dp(4));
        item.setBackground(selected
                ? round(Color.rgb(42, 29, 23), 14)
                : round(Color.TRANSPARENT, 14));
        item.setOnClickListener(v -> {
            if (label.equals("خانه")) showHome();
            else if (label.equals("ماشین‌ها")) showMachines();
            else if (label.equals("دانلودها")) showDownloads();
            else showSettings();
        });
        return item;
    }

    void showMachines() {
        setSelectedTab("ماشین‌ها");
        content.removeAllViews();
        pageTitle("ماشین‌های من");

        LinearLayout heading = new LinearLayout(this);
        heading.setGravity(Gravity.CENTER_VERTICAL);
        heading.addView(text("ماشین‌های مجازی", 17, WHITE, true),
                new LinearLayout.LayoutParams(0, -2, 1));
        TextView add = text("＋", 28, ORANGE, true);
        add.setGravity(Gravity.CENTER);
        add.setOnClickListener(v -> showCreate());
        heading.addView(add, params(42, 42));
        space(14);
        content.addView(heading);

        space(8);
        LinearLayout linux = panel();
        linux.setPadding(dp(14), dp(14), dp(14), dp(14));
        linux.setBackground(roundGradient(
                new int[]{Color.rgb(34, 28, 24), Color.rgb(18, 22, 27)}, 18));
        linux.setOrientation(LinearLayout.VERTICAL);

        LinearLayout top = new LinearLayout(this);
        top.setGravity(Gravity.CENTER_VERTICAL);
        TextView penguin = text("🐧", 32, WHITE, true);
        penguin.setGravity(Gravity.CENTER);
        top.addView(penguin, params(48, 48));
        LinearLayout details = new LinearLayout(this);
        details.setOrientation(LinearLayout.VERTICAL);
        details.setPadding(dp(10), 0, 0, 0);
        details.addView(text("Linux", 16, WHITE, true));
        spaceIn(details, 3);
        details.addView(text("Alpine Linux 3.20", 11, MUTED, false));
        top.addView(details, new LinearLayout.LayoutParams(0, -2, 1));
        TextView status = text("پیش‌نمایش", 10, MUTED, true);
        status.setBackground(round(Color.rgb(43, 47, 54), 12));
        status.setPadding(dp(9), dp(6), dp(9), dp(6));
        top.addView(status);
        linux.addView(top);

        spaceIn(linux, 14);
        LinearLayout specs = new LinearLayout(this);
        specs.addView(text("▣  1.2 GB RAM", 10, WHITE, false),
                new LinearLayout.LayoutParams(0, -2, 1));
        specs.addView(text("⚙  2 vCPU", 10, WHITE, false),
                new LinearLayout.LayoutParams(0, -2, 1));
        specs.addView(text("▤  8 GB دیسک", 10, WHITE, false),
                new LinearLayout.LayoutParams(0, -2, 1));
        linux.addView(specs);
        linux.setOnClickListener(v -> showMachineDetails());
        content.addView(linux);

        space(14);
        content.addView(createMachineRow(
                "Ubuntu", "Ubuntu 24.04 · هنوز ساخته نشده", "پیش‌نمایش", "◈"));
        space(10);
        content.addView(createMachineRow(
                "Debian", "Debian 12 · هنوز ساخته نشده", "پیش‌نمایش", "D"));

        space(24);
        LinearLayout storage = panel();
        storage.setPadding(dp(14), dp(14), dp(14), dp(14));
        storage.setOrientation(LinearLayout.VERTICAL);
        storage.addView(text("فضای ذخیره‌سازی", 14, WHITE, true));
        spaceIn(storage, 8);
        LinearLayout storageLine = new LinearLayout(this);
        storageLine.setGravity(Gravity.CENTER_VERTICAL);
        storageLine.addView(text("فضای استفاده‌شده", 11, MUTED, false),
                new LinearLayout.LayoutParams(0, -2, 1));
        storageLine.addView(text("۰ / ۳۲ GB", 11, MUTED, false));
        storage.addView(storageLine);
        spaceIn(storage, 10);
        View progress = new View(this);
        progress.setBackground(round(Color.rgb(43, 47, 54), 8));
        storage.addView(progress, new LinearLayout.LayoutParams(-1, dp(6)));
        content.addView(storage);

        space(18);
        actionButton("＋  ساخت ماشین جدید", this::showCreate);
    }

    void showMachineDetails() {
        content.removeAllViews();
        setSelectedTab("ماشین‌ها");
        pageTitle("جزئیات ماشین مجازی");
        space(14);
        LinearLayout hero = panel();
        hero.setPadding(dp(14), dp(14), dp(14), dp(14));
        hero.setOrientation(LinearLayout.VERTICAL);
        LinearLayout top = new LinearLayout(this);
        top.setGravity(Gravity.CENTER_VERTICAL);
        top.addView(text("🐧", 32, WHITE, true), params(50, 50));
        LinearLayout info = new LinearLayout(this);
        info.setOrientation(LinearLayout.VERTICAL);
        info.setPadding(dp(10), 0, 0, 0);
        info.addView(text("Linux", 17, WHITE, true));
        info.addView(text("Alpine Linux 3.20 (ARM64)", 11, MUTED, false));
        info.addView(text("پیکربندی نمایشی · اجرا غیرفعال", 10, MUTED, false));
        top.addView(info);
        hero.addView(top);
        content.addView(hero);
        space(18);
        content.addView(text("تنظیمات سریع", 17, WHITE, true));
        space(10);
        content.addView(settingSlider("حافظهٔ RAM", ramValue + " GB", ramValue, 16, "ram"));
        space(9);
        content.addView(settingSlider("پردازنده (vCPU)", cpuValue + " vCPU", cpuValue, 8, "cpu"));
        space(9);
        content.addView(settingSlider("فضای ذخیره‌سازی", diskValue + " GB", diskValue, 64, "disk"));
        space(16);
        actionButton("اجرا  ▶", () -> Toast.makeText(this,
                "این پیش‌نمایش است؛ هنوز ماشین واقعی اجرا نمی‌شود.",
                Toast.LENGTH_LONG).show());
        space(8);
        actionButton("باز کردن کنسول", this::showConsole);
        space(8);
        actionButton("پیش‌نمایش صفحهٔ شروع", this::showStartup);
        space(8);
        TextView back = text("بازگشت به ماشین‌ها", 13, MUTED, true);
        back.setGravity(Gravity.CENTER);
        back.setPadding(0, dp(10), 0, dp(10));
        back.setOnClickListener(v -> showMachines());
        content.addView(back);
    }

    void showCreate() {
        setSelectedTab("ماشین‌ها");
        content.removeAllViews();
        pageTitle("ساخت ماشین مجازی");

        space(18);
        LinearLayout hero = panel();
        hero.setOrientation(LinearLayout.HORIZONTAL);
        hero.setGravity(Gravity.CENTER_VERTICAL);
        hero.setPadding(dp(16), dp(16), dp(16), dp(16));
        hero.setBackground(roundGradient(
                new int[]{Color.rgb(43, 28, 22), Color.rgb(20, 23, 28)}, 18));

        TextView penguin = text("🐧", 35, WHITE, true);
        penguin.setGravity(Gravity.CENTER);
        hero.addView(penguin, params(54, 60));

        LinearLayout heroInfo = new LinearLayout(this);
        heroInfo.setOrientation(LinearLayout.VERTICAL);
        heroInfo.setPadding(dp(12), 0, 0, 0);
        heroInfo.addView(text("Linux", 20, WHITE, true));
        spaceIn(heroInfo, 4);
        heroInfo.addView(text("انتخاب سیستم‌عامل", 12, MUTED, false));
        hero.addView(heroInfo, new LinearLayout.LayoutParams(0, -2, 1));
        content.addView(hero);

        space(20);
        content.addView(text("سیستم‌عامل", 17, WHITE, true));
        space(5);
        content.addView(text("توزیع موردنظرت را انتخاب کن.", 12, MUTED, false));
        space(12);

        content.addView(createOsOption("Alpine Linux",
                "سبک و سریع · ARM64", "▲", Color.rgb(26, 89, 126)));
        space(10);
        content.addView(createOsOption("Debian",
                "پایدار و حرفه‌ای · ARM64", "◉", Color.rgb(150, 20, 47)));
        space(10);
        content.addView(createOsOption("Ubuntu",
                "محبوب و قدرتمند · ARM64", "◈", Color.rgb(220, 61, 24)));
        space(10);
        content.addView(createOsOption("Fedora",
                "به‌روز و ایمن · ARM64", "f", Color.rgb(20, 82, 165)));

        space(16);
        LinearLayout summary = panel();
        summary.setPadding(dp(14), dp(13), dp(14), dp(13));
        summary.setOrientation(LinearLayout.VERTICAL);
        summary.addView(text("انتخاب فعلی", 11, MUTED, false));
        spaceIn(summary, 5);
        summary.addView(text(selectedOs, 15, ORANGE, true));
        spaceIn(summary, 5);
        summary.addView(text("ساخت ماشین پس از اتصال موتور QEMU فعال می‌شود.",
                11, MUTED, false));
        content.addView(summary);

        space(16);
        actionButton("ادامه  ▶", () -> Toast.makeText(this,
                selectedOs + " انتخاب شد؛ ساخت ماشین هنوز به موتور QEMU نیاز دارد.",
                Toast.LENGTH_LONG).show());
        space(10);
        TextView back = text("بازگشت", 13, MUTED, true);
        back.setGravity(Gravity.CENTER);
        back.setPadding(0, dp(10), 0, dp(10));
        back.setOnClickListener(v -> showHome());
        content.addView(back);
    }

    View createOsOption(String name, String description,
                        String symbol, int iconColor) {
        boolean selected = name.equals(selectedOs);
        LinearLayout row = new LinearLayout(this);
        row.setGravity(Gravity.CENTER_VERTICAL);
        row.setPadding(dp(13), dp(13), dp(13), dp(13));
        GradientDrawable background = round(
                selected ? Color.rgb(32, 26, 23) : CARD, 16);
        background.setStroke(dp(selected ? 1 : 1),
                selected ? ORANGE : Color.rgb(38, 43, 51));
        row.setBackground(background);

        TextView icon = text(symbol, 22, WHITE, true);
        icon.setGravity(Gravity.CENTER);
        icon.setBackground(round(iconColor, 13));
        row.addView(icon, params(44, 44));

        LinearLayout info = new LinearLayout(this);
        info.setOrientation(LinearLayout.VERTICAL);
        info.setPadding(dp(12), 0, 0, 0);
        info.addView(text(name, 14, WHITE, true));
        spaceIn(info, 4);
        info.addView(text(description, 11, MUTED, false));
        row.addView(info, new LinearLayout.LayoutParams(0, -2, 1));

        TextView radio = text(selected ? "◉" : "○", 23,
                selected ? ORANGE : MUTED, true);
        radio.setGravity(Gravity.CENTER);
        row.addView(radio, params(30, 40));

        row.setOnClickListener(v -> {
            selectedOs = name;
            showCreate();
        });
        return row;
    }


    View settingSlider(String title, String initialValue, int initial, int max, String type) {
        LinearLayout box = panel();
        box.setPadding(dp(14), dp(12), dp(14), dp(10));
        box.setOrientation(LinearLayout.VERTICAL);
        LinearLayout labels = new LinearLayout(this);
        labels.setGravity(Gravity.CENTER_VERTICAL);
        labels.addView(text(title, 13, WHITE, true), new LinearLayout.LayoutParams(0, -2, 1));
        TextView value = text(initialValue, 12, MUTED, true);
        labels.addView(value);
        box.addView(labels);
        SeekBar seek = new SeekBar(this);
        seek.setMax(max);
        seek.setProgress(initial);
        seek.setProgressTintList(android.content.res.ColorStateList.valueOf(ORANGE));
        seek.setThumbTintList(android.content.res.ColorStateList.valueOf(ORANGE));
        box.addView(seek, new LinearLayout.LayoutParams(-1, dp(34)));
        seek.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            public void onProgressChanged(SeekBar bar, int progress, boolean fromUser) {
                int n = Math.max(1, progress);
                value.setText(type.equals("cpu") ? n + " vCPU" : n + " GB");
                if (type.equals("ram")) ramValue = n;
                else if (type.equals("cpu")) cpuValue = n;
                else diskValue = n;
            }
            public void onStartTrackingTouch(SeekBar bar) {}
            public void onStopTrackingTouch(SeekBar bar) {}
        });
        return box;
    }

    void showConsole() {
        content.removeAllViews();
        setSelectedTab("ماشین‌ها");
        pageTitle("کنسول ماشین");
        space(14);
        LinearLayout top = panel();
        top.setPadding(dp(12), dp(12), dp(12), dp(12));
        top.setGravity(Gravity.CENTER_VERTICAL);
        top.addView(text("🐧", 30, WHITE, true), params(46, 46));
        LinearLayout info = new LinearLayout(this);
        info.setOrientation(LinearLayout.VERTICAL);
        info.setPadding(dp(10), 0, 0, 0);
        info.addView(text("Linux", 15, WHITE, true));
        info.addView(text("پیش‌نمایش کنسول · ماشین اجرا نیست", 10, GREEN, false));
        top.addView(info);
        content.addView(top);
        space(10);
        TextView terminal = text("PocketVM Console / Alpine Linux 3.20\n\nWelcome to Alpine Linux!\nThis is a UI preview. No virtual machine is running.\n\nalpine:~$ _", 12, Color.rgb(214, 224, 218), false);
        terminal.setGravity(Gravity.TOP | Gravity.LEFT);
        terminal.setTypeface(Typeface.MONOSPACE);
        terminal.setPadding(dp(14), dp(16), dp(14), dp(16));
        terminal.setMinHeight(dp(320));
        terminal.setBackground(round(Color.rgb(4, 8, 11), 16));
        content.addView(terminal, new LinearLayout.LayoutParams(-1, 0, 1));
        space(10);
        actionButton("بازگشت به جزئیات", this::showMachineDetails);
    }

    void showStartup() {
        content.removeAllViews();
        setSelectedTab("ماشین‌ها");
        LinearLayout screen = new LinearLayout(this);
        screen.setGravity(Gravity.CENTER);
        screen.setOrientation(LinearLayout.VERTICAL);
        screen.setPadding(dp(20), dp(40), dp(20), dp(40));
        screen.setBackground(roundGradient(new int[]{Color.rgb(35, 24, 20), BG, Color.rgb(10, 15, 21)}, 24));
        TextView penguin = text("🐧", 64, WHITE, true);
        penguin.setGravity(Gravity.CENTER);
        screen.addView(penguin, params(100, 100));
        spaceIn(screen, 18);
        screen.addView(text("Alpine Linux", 23, WHITE, true));
        spaceIn(screen, 8);
        screen.addView(text("پیش‌نمایش صفحهٔ راه‌اندازی", 12, MUTED, false));
        spaceIn(screen, 24);
        View progress = new View(this);
        progress.setBackground(round(ORANGE, 8));
        screen.addView(progress, new LinearLayout.LayoutParams(dp(90), dp(5)));
        spaceIn(screen, 26);
        screen.addView(text("برای بازگشت، روی صفحه بزن", 11, MUTED, false));
        content.addView(screen, new LinearLayout.LayoutParams(-1, -1));
        screen.setOnClickListener(v -> showMachineDetails());
    }

    void showDownloads() {
        setSelectedTab("دانلودها");
        content.removeAllViews();
        pageTitle("دانلودها");
        space(12);
        content.addView(text("سیستم‌عامل‌ها", 18, WHITE, true));
        space(5);
        content.addView(text("فهرست توزیع‌های لینوکس برای معماری ARM64",
                11, MUTED, false));
        space(12);
        LinearLayout filters = new LinearLayout(this);
        String[] filterNames = {"همه", "سبک", "محبوب"};
        for (String filter : filterNames) {
            TextView chip = text(filter, 12,
                    filter.equals(downloadFilter) ? Color.BLACK : MUTED, true);
            chip.setGravity(Gravity.CENTER);
            chip.setPadding(dp(14), dp(9), dp(14), dp(9));
            chip.setBackground(round(filter.equals(downloadFilter)
                    ? ORANGE : CARD, 18));
            LinearLayout.LayoutParams cp = new LinearLayout.LayoutParams(-2, dp(38));
            cp.setMargins(0, 0, dp(8), 0);
            filters.addView(chip, cp);
            chip.setOnClickListener(v -> {
                downloadFilter = filter;
                showDownloads();
            });
        }
        content.addView(filters);
        space(14);

        String[][] os = {
                {"Alpine Linux", "3.20 (ARM64)", "سبک و سریع", "▲", "سبک"},
                {"Ubuntu", "24.04 (ARM64)", "محبوب و قدرتمند", "◈", "محبوب"},
                {"Debian", "12 (ARM64)", "پایدار و حرفه‌ای", "D", "محبوب"},
                {"Fedora", "41 (ARM64)", "به‌روز و ایمن", "f", "محبوب"},
                {"Arch Linux", "ARM64", "سریع و منعطف", "A", "سبک"}
        };
        int[] colors = {
                Color.rgb(26, 89, 126), Color.rgb(220, 61, 24),
                Color.rgb(150, 20, 47), Color.rgb(20, 82, 165),
                Color.rgb(30, 94, 150)
        };
        int shown = 0;
        for (int i = 0; i < os.length; i++) {
            if (!downloadFilter.equals("همه") && !downloadFilter.equals(os[i][4])) continue;
            final String name = os[i][0];
            LinearLayout item = new LinearLayout(this);
            item.setGravity(Gravity.CENTER_VERTICAL);
            item.setPadding(dp(12), dp(12), dp(12), dp(12));
            item.setBackground(round(CARD, 16));
            TextView icon = text(os[i][3], 21, WHITE, true);
            icon.setGravity(Gravity.CENTER);
            icon.setBackground(round(colors[i], 12));
            item.addView(icon, params(44, 44));
            LinearLayout info = new LinearLayout(this);
            info.setOrientation(LinearLayout.VERTICAL);
            info.setPadding(dp(12), 0, 0, 0);
            info.addView(text(name, 13, WHITE, true));
            spaceIn(info, 3);
            info.addView(text(os[i][1] + " · " + os[i][2], 10, MUTED, false));
            item.addView(info, new LinearLayout.LayoutParams(0, -2, 1));
            TextView download = text("↓", 22, MUTED, true);
            download.setGravity(Gravity.CENTER);
            item.addView(download, params(36, 40));
            item.setOnClickListener(v -> Toast.makeText(this,
                    "دانلود " + name + " هنوز پیاده‌سازی نشده است.",
                    Toast.LENGTH_LONG).show());
            content.addView(item);
            space(9);
            shown++;
        }
        if (shown == 0) content.addView(text("موردی در این دسته نیست.", 12, MUTED, false));
        space(6);
        content.addView(text("هیچ فایلی دانلود نشده است.",
                12, MUTED, false));
    }

    void showSettings() {
        setSelectedTab("تنظیمات");
        content.removeAllViews();
        pageTitle("تنظیمات");
        space(18);

        String[][] items = {
                {"⚙", "عمومی", "زبان، ظاهر و اعلان‌ها"},
                {"◇", "شبکه", "اتصال و دسترسی اینترنت"},
                {"▤", "ذخیره‌سازی", "مدیریت فضای ماشین‌ها"},
                {"◈", "عملکرد", "بهینه‌سازی و منابع"},
                {"ⓘ", "درباره", "نسخه و اطلاعات برنامه"}
        };
        for (String[] item : items) {
            LinearLayout row = new LinearLayout(this);
            row.setGravity(Gravity.CENTER_VERTICAL);
            row.setPadding(dp(14), dp(15), dp(14), dp(15));
            row.setBackground(round(CARD, 12));
            TextView icon = text(item[0], 22, WHITE, false);
            icon.setGravity(Gravity.CENTER);
            row.addView(icon, params(36, 42));
            LinearLayout info = new LinearLayout(this);
            info.setOrientation(LinearLayout.VERTICAL);
            info.setPadding(dp(12), 0, 0, 0);
            info.addView(text(item[1], 14, WHITE, true));
            spaceIn(info, 4);
            info.addView(text(item[2], 10, MUTED, false));
            row.addView(info, new LinearLayout.LayoutParams(0, -2, 1));
            TextView arrow = text("›", 23, MUTED, false);
            row.addView(arrow);
            row.setOnClickListener(v -> showSettingSection(item[1]));
            content.addView(row);
            space(1);
        }
        space(22);
        content.addView(text("PocketVM · نسخهٔ آزمایشی", 11, MUTED, false));
    }

    void showSettingSection(String section) {
        content.removeAllViews();
        pageTitle(section);
        space(18);
        LinearLayout card = panel();
        card.setPadding(dp(16), dp(16), dp(16), dp(16));
        card.addView(text(section, 18, WHITE, true));
        spaceIn(card, 10);
        card.addView(text("این بخش نمایشی است و تنظیمات سیستمی هنوز فعال نیستند.", 13, MUTED, false));
        content.addView(card);
        space(18);
        actionButton("بازگشت به تنظیمات", this::showSettings);
    }

    void pageTitle(String title) {
        TextView heading = text(title, 24, WHITE, true);
        content.addView(heading);
        space(6);
        content.addView(text("PocketVM  /  مدیریت ماشین مجازی",
                12, MUTED, false));
    }

    void actionButton(String label, Runnable action) {
        TextView button = text(label, 15, Color.BLACK, true);
        button.setGravity(Gravity.CENTER);
        button.setPadding(dp(12), dp(16), dp(12), dp(16));
        button.setBackground(round(ORANGE, 15));
        button.setOnClickListener(v -> action.run());
        content.addView(button);
    }

    LinearLayout panel() {
        LinearLayout view = new LinearLayout(this);
        view.setOrientation(LinearLayout.VERTICAL);
        view.setBackground(round(CARD, 17));
        return view;
    }

    TextView text(String value, float size, int color, boolean bold) {
        TextView view = new TextView(this);
        view.setText(value);
        view.setTextSize(size);
        view.setTextColor(color);
        view.setGravity(Gravity.RIGHT | Gravity.CENTER_VERTICAL);
        if (bold) view.setTypeface(Typeface.DEFAULT, Typeface.BOLD);
        return view;
    }

    GradientDrawable round(int color, int radius) {
        GradientDrawable d = new GradientDrawable();
        d.setColor(color);
        d.setCornerRadius(dp(radius));
        return d;
    }

    GradientDrawable roundGradient(int[] colors, int radius) {
        GradientDrawable d = new GradientDrawable(
                GradientDrawable.Orientation.TL_BR, colors);
        d.setCornerRadius(dp(radius));
        d.setStroke(dp(1), Color.rgb(88, 49, 29));
        return d;
    }

    LinearLayout.LayoutParams params(int width, int height) {
        return new LinearLayout.LayoutParams(dp(width), dp(height));
    }

    View gap(int width) {
        View view = new View(this);
        view.setMinimumWidth(dp(width));
        return view;
    }

    void space(int height) {
        content.addView(new View(this),
                new LinearLayout.LayoutParams(1, dp(height)));
    }

    void spaceIn(LinearLayout box, int height) {
        box.addView(new View(this),
                new LinearLayout.LayoutParams(1, dp(height)));
    }

    int dp(float value) {
        return (int) (value * getResources()
                .getDisplayMetrics().density + 0.5f);
    }
}
