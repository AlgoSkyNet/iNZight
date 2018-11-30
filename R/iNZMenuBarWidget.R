iNZMenuBarWidget <- setRefClass(
    "iNZMenuBarWidget",
    fields = list(
        GUI = "ANY", container = "ANY", disposeR = "logical",
        menubar = "ANY",
        plotmenu = "ANY"
    ),
    methods = list(
        initialize = function(gui, container, disposeR) {
            initFields(GUI = gui, container = container, disposeR = disposeR)
        
            ## this is trickier, because it depends on a bunch of things 
            plotmenu <<- placeholder("Plot")
            menubar <<- gmenu(list(), container = container)

            defaultMenu()
        },
        hasData = function() {
            !all(dim(GUI$getActiveData()) == 1)
        },
        placeholder = function(name) {
            x <- gaction(name)
            enabled(x) <- FALSE
            x
        },
        defaultMenu = function() {
            setMenu(
                File = FileMenu(), 
                Dataset = DataMenu(),
                Variables = VariablesMenu(),
                Plot = PlotMenu(),
                Advanced = AdvancedMenu(),
                Help = HelpMenu()
            )
        },
        setMenu = function(...) {
            svalue(menubar) <<- list(...)
        },
        updateMenu = function(what, with) {
            svalue(menubar)[[what]] <<- with
        },
        FileMenu = function() {
            list(
                load = 
                    gaction("Load ...", 
                        icon = "symbol_diamond",
                        handler = function(h, ...) iNZLoadSaveWin$new(GUI, action = "load")),
                save = 
                    gaction("Save ...", 
                        icon = "save",
                        handler = function(h, ...) iNZLoadSaveWin$new(GUI, action = "save")),
                gseparator(),
                import = 
                    gaction("Import data ...",
                        icon = "symbol_diamond",
                        tooltip = "Import a new dataset",
                        handler = function(h, ...) iNZImportWinBeta$new(GUI)),
                export = 
                    gaction("Export data ...", 
                        icon = "symbol_diamond",
                        handler = function(h, ...) iNZSaveWin$new(GUI, type = "data", data = GUI$getActiveData())),
                gseparator(),
                example = 
                    gaction("Example data ...", 
                        icon = "symbol_diamond",
                        tooltip = "Load an example dataset",
                        handler = function(h, ...) iNZImportExampleWin$new(GUI)),
                gseparator(),
                preferences = 
                    gaction ("Preferences ...",
                        icon = "symbol_diamond",
                        tooltip = "Customise iNZight",
                        handler = function(h, ...) iNZPrefsWin$new(.self)),
                exit = 
                    gaction("Exit",
                        icon = "symbol_diamond",
                        handler = function(h, ...) GUI$close())
            )
        },
        DataMenu = function() {
            if (!hasData()) return(placeholder("Dataset"))
            list(
                filter = 
                    gaction("Filter ...",
                        icon = "symbol_diamond",
                        handler = function(h, ...) iNZFilterWin$new(GUI)),
                sort = 
                    gaction("Sort by variable(s) ...",
                        icon = "symbol_diamond",
                        handler = function(h, ...) iNZSortbyDataWin$new(GUI)),
                aggregate = 
                    gaction("Aggregate ...",
                        icon = "symbol_diamond",
                        handler = function(h, ...) iNZAgraDataWin$new(GUI)),
                stack = 
                    gaction("Stack ...",
                        icon = "symbol_diamond",
                        handler = function(h, ...) iNZstackVarWin$new(GUI)),
                gseparator(),
                rename = 
                    gaction("Rename ...",
                        icon = "symbol_diamond",
                        handler = function(h, ...) iNZrenameDataWin$new(GUI)),
                restore = 
                    gaction("Restore original dataset",
                        icon = "symbol_diamond",
                        handler = function(h, ...) GUI$restoreDataset()),
                delete = 
                    gaction("Delete current dataset",
                        icon = "symbol_diamond",
                        handler = function(h, ...) GUI$deleteDataset()),
                gseparator(),
                surveydesign = 
                    gaction("Specify survey design [beta] ...",
                        icon = "symbol_diamond",
                        handler = function(h, ...) iNZSurveyDesign$new(GUI)),
                removedesign = 
                    gaction("Remove design",
                        icon = "symbol_diamond",
                        handler = function(h, ...) GUI$removeDesign()),
                gseparator(),
                expandtable = 
                    gaction("Expand table",
                        icon = "symbol_diamond",
                        handler = function(h, ...) iNZexpandTblWin$new(GUI))
            )
        },
        VariablesMenu = function() {
            if (!hasData()) return(placeholder("Variables"))
            list(
                cont2cat = 
                    gaction("Convert to categorical ...",
                        icon = "symbol_diamond",
                        tooltip = "Convert a variable to a categorical type",
                        handler = function(h, ...) iNZconToCatWin$new(GUI)),
                "Categorical Variables" = list(
                    reorder = 
                        gaction("Reorder levels ...",
                            icon = "symbol_diamond",
                            tooltip = "Reorder the levels of a categorical variable",
                            handler = function(h, ...) iNZreorderWin$new(GUI)),
                    collapse = 
                        gaction("Collapse levels ...",
                            icon = "symbol_diamond",
                            tooltip = "Collapse two or more levels into one",
                            handler = function(h, ...) iNZcllpsWin$new(GUI)),
                    rename = 
                        gaction("Rename levels ...",
                            icon = "symbol_diamond",
                            tooltip = "Rename a categorical variable's levels",
                            handler = function(h, ...) iNZrenameWin$new(GUI)),
                    combine = 
                        gaction("Combine categorical variables ...",
                            icon = "symbol_diamond",
                            tooltip = "Combine two or more categorical variables",
                            handler = function(h, ...) iNZcmbCatWin$new(GUI))
                    ),
                "Numeric Variables" = list(
                    transform = 
                        gaction("Transform ...",
                            icon = "symbol_diamond",
                            tooltip = "Transform a variable using a function",
                            handler = function(h, ...) iNZtrnsWin$new(GUI)),
                    standardise = 
                        gaction("Standardise ...",
                            icon = "symbol_diamond",
                            tooltip = "Standardise a numeric variable",
                            handler = function(h, ...) iNZstdVarWin$new(GUI)),
                    class = 
                        gaction("Form class intervals ...",
                            icon = "symbol_diamond",
                            tooltip = "Convert numeric variable into categorical intervals",
                            handler = function(h, ...) iNZfrmIntWin$new(GUI)),
                    rank = 
                        gaction("Rank numeric variables ...",
                            icon = "symbol_diamond",
                            tooltip = "Create an ordering variable",
                            handler = function(h, ...) iNZrankNumWin$new(GUI)),
                    cat = 
                        gaction("Convert to categorical (multiple) ...",
                            icon = "symbol_diamond",
                            tooltip = "Convert multiple numeric variables to categorical",
                            handler = function(h, ...) iNZctocatmulWin$new(GUI))
                    ),
                rename =
                    gaction("Rename variables ...",
                        icon = "symbol_diamond",
                        tooltip = "Rename a variable",
                        handler = function(h, ...) iNZrnmVarWin$new(GUI)),
                create =
                    gaction("Create new variables ...",
                        icon = "symbol_diamond",
                        tooltip = "Create a new variable using a formula",
                        handler = function(h, ...) iNZcrteVarWin$new(GUI)),
                miss2cat =
                    gaction("Missing to categorical ...",
                        icon = "symbol_diamond",
                        tooltip = "Create a variable to include missingness information",
                        handler = function(h, ...) iNZmissCatWin$new(GUI)),
                reshape = 
                    gaction("Reshape dataset ...",
                        icon = "symbol_diamond",
                        tooltip = "Transform from wide- to long-form data",
                        handler = function(h, ...) iNZReshapeDataWin$new(GUI)),
                delete = 
                    gaction("Delete variables ...",
                        icon = "symbol_diamond",
                        tooltip = "Permanently delete a variable",
                        handler = function(h, ...) iNZdeleteVarWin$new(GUI))
            )
        },
        PlotMenu = function() {
            if (!hasData()) return(placeholder("Plot"))
            plotmenu
        },
        setPlotMenu = function(menu) {
            plotmenu <<- menu
            updateMenu("Plot", PlotMenu())
        },
        AdvancedMenu = function() {
            if (!hasData()) return(placeholder("Advanced"))
            list(
                "Quick Explore" = list(
                    missing = 
                        gaction("Missing values",
                            icon = "symbol_diamond",
                            tooltip = "Explore missing values",
                            handler = function(h, ...) iNZExploreMissing$new(GUI)),
                    all1varplot = 
                        gaction("All 1-variable plots",
                            icon = "symbol_diamond",
                            tooltip = "Click through a plot of each variable",
                            handler = function(h, ...) iNZallPlots$new(GUI)),
                    all2varsmry = 
                        gaction("All 1-variable summaries",
                            icon = "symbol_diamond",
                            tooltip = "Get a summary of all variables",
                            handler = function(h, ...) iNZallSummaries$new(GUI)),
                    all2var = 
                        gaction("Explore 2-variable plots ...",
                            icon = "symbol_diamond",
                            tooltip = "Click through all 2-variable plots",
                            handler = function(h, ...) iNZall2Plots$new(GUI)),
                    pairs = 
                        gaction("Pairs ...",
                            icon = "symbol_diamond",
                            tooltip = "See a pairs plot matrix",
                            handler = function(h, ...) iNZscatterMatrix$new(GUI))
                ),
                plot3d = 
                    gaction("3D plot ...",
                        icon = "symbol_diamond",
                        tooltip = "Start the 3D plotting module",
                        handler = function(h, ...) {
                            ign <- gwindow("...", visible = FALSE)
                            tag(ign, "dataSet") <- GUI$getActiveData()
                            e <- list(obj = ign)
                            e$win <- GUI$win
                            iNZightModules::plot3D(e)
                        }),
                timeseries =
                    gaction("Time series ...",
                        icon = "symbol_diamond",
                        tooltip = "Start the time series module",
                        handler = function(h, ...) iNZightModules::iNZightTSMod$new(GUI)),
                modelfitting =
                    gaction("Model fitting ...",
                        icon = "symbol_diamond",
                        tooltip = "Start the model fitting module",
                        handler = function(h, ...) iNZightModules::iNZightRegMod$new(GUI)),
                multires =
                    gaction("Multiple response ...",
                        icon = "symbol_diamond",
                        tooltip = "Start the multiple response module",
                        handler = function(h, ...) iNZightModules::iNZightMultiRes$new(GUI)),
                ## this will become a single option at some point ...
                "Maps" = list(
                    points = 
                        gaction("Latitude/longitude points ...",
                            icon = "symbol_diamond",
                            tooltip = "Start the maps module for lat/lon point data",
                            handler = function(h, ...) iNZightModules::iNZightMapMod$new(GUI)),
                    regions =
                        gaction("Regions/countries ...",
                            icon = "symbol_diamond",
                            tooltip = "Start the maps module for regional data",
                            handler = function(h, ...) iNZightModules::iNZightMap2Mod$new(GUI))
                ),
                gseparator(),
                rcode = 
                    gaction("R code history [beta] ...",
                        icon = "symbol_diamond",
                        tooltip = "Show the R code history for your session",
                        handler = function(h, ...) GUI$showHistory())
            )
        },
        HelpMenu = function() {
            guides <- list(user_guides.basics = "The Basics",
                           user_guides.interface = "The Interface",
                           user_guides.plot_options = "Plot Options",
                           user_guides.variables = "Variables menu",
                           user_guides.data_options = "Dataset menu",
                           user_guides.add_ons = "Advanced")
            list(
                about = 
                    gaction("About",
                        icon = "symbol_diamond",
                        tooltip = "",
                        handler = function(h, ...) iNZAboutWidget$new(GUI)),
                "User Guides" = lapply(
                    names(guides), 
                    function(n) {
                        gaction(
                            guides[[n]],
                            icon = "symbol_diamond", 
                            tooltip = "",
                            handler = function(h, ...) {
                                browseURL(
                                    sprintf(
                                        "https://www.stat.auckland.ac.nz/~wild/iNZight/%s",
                                        gsub(".", "/", n)
                                    )
                                )
                            }
                        )
                    }
                ),    
                change = 
                    gaction("Change history",
                        icon = "symbol_diamond",
                        tooltip = "",
                        handler = function(h, ...) 
                            browseURL('https://www.stat.auckland.ac.nz/~wild/iNZight/support/changelog/?pkg=iNZight')),
                faq = 
                    gaction("FAQ",
                        icon = "symbol_diamond",
                        tooltip = "",
                        handler = function(h, ...) 
                            browseURL("https://www.stat.auckland.ac.nz/~wild/iNZight/support/faq/")),
                contact = 
                    gaction("Contact us or Report a Bug",
                        icon = "symbol_diamond",
                        tooltip = "",
                        handler = function(h, ...) 
                            browseURL("https://www.stat.auckland.ac.nz/~wild/iNZight/support/contact/"))
            )
        }
    )
)


iNZAboutWidget <- setRefClass(
    "iNZAboutWidget",
    fields = list(
        GUI = "ANY"
    ),
    methods = list(
        initialize = function(gui) {
            initFields(GUI = gui)

            w <- gwindow("About iNZight", width = 500, height = 400, visible = TRUE, parent = GUI$win)
            g <- gvbox(expand = FALSE, cont = w, spacing = 5)
            g$set_borderwidth(10)
            mainlbl <- glabel("iNZight", container = g)
            font(mainlbl) <- list(weight = "bold", family = "normal", size = 20)
            verlbl <- glabel(sprintf("Version %s - Released %s",
                                     packageDescription("iNZight")$Version,
                                     format(as.POSIXct(packageDescription("iNZight")$Date),
                                            "%d %B, %Y")), container = g)
            font(verlbl) <- list(weight = "normal", family = "normal", size = 10)
            rverlbl <- glabel(sprintf("Running on R version %s", getRversion()), container = g)
            font(rverlbl) <- list(weight = "normal", family = "normal", size = 10)
            addSpace(g, 10)
            gpltxt <- gtext(expand = TRUE, cont = g, wrap = TRUE)
            insert(gpltxt, paste("\n\nThis program is free software; you can redistribute it and/or",
                                 "modify it under the terms of the GNU General Public License",
                                 "as published by the Free Software Foundation; either version 2",
                                 "of the License, or (at your option) any later version.\n"),
                   font.attr = list(size = 9)) -> l1
            insert(gpltxt, paste("This program is distributed in the hope that it will be useful,",
                                 "but WITHOUT ANY WARRANTY; without even the implied warranty of",
                                 "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the",
                                 "GNU General Public License for more details.\n"),
                   font.attr = list(size = 9)) -> l2
            insert(gpltxt, paste("You should have received a copy of the GNU General Public License",
                                 "along with this program; if not, write to the Free Software",
                                 "Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.\n"),
                   font.attr = list(size = 9)) -> l3
            insert(gpltxt, paste("You can view the full licence here:\nhttp://www.gnu.org/licenses/gpl-2.0-standalone.html"),
                   font.attr = list(size = 9)) -> l4
            addSpace(g, 5)
            contactlbl <- glabel("For help, contact inzight_support@stat.auckland.ac.nz", container = g)
            font(contactlbl) <- list(weight = "normal", family = "normal", size = 8)
            visible(w) <- TRUE
        }
    )
)