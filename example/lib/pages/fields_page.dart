import 'package:flutter/cupertino.dart' hide OverlayVisibilityMode;
import 'package:macos_ui/macos_ui.dart';

class FieldsPage extends StatefulWidget {
  const FieldsPage({super.key});

  @override
  State<FieldsPage> createState() => _FieldsPageState();
}

class _FieldsPageState extends State<FieldsPage> {
  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: ToolBar(
        title: const Text('Fields'),
        titleWidth: 150.0,
        actions: [
          ToolBarIconButton(
            label: 'Toggle Sidebar',
            icon: const MacosIcon(
              CupertinoIcons.sidebar_left,
            ),
            onPressed: () => MacosWindowScope.of(context).toggleSidebar(),
            showLabel: false,
          ),
        ],
      ),
      children: [
        ContentArea(builder: (context, scrollController) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(
                  width: 300.0,
                  child: MacosTextField(
                    placeholder: 'Type some text here',
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 20),
                const SizedBox(
                  width: 300.0,
                  child: MacosTextField(
                    prefix: MacosIcon(CupertinoIcons.money_dollar),
                    placeholder: 'Type some text here',

                    /// If both suffix and clear button mode is provided,
                    /// suffix will override the clear button.
                    // suffix: Text('SUFFIX'),
                    clearButtonMode: OverlayVisibilityMode.always,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 20),
                const SizedBox(
                  width: 300.0,
                  child: MacosTextField.borderless(
                    prefix: MacosIcon(CupertinoIcons.search),
                    placeholder: 'Type some text here',

                    /// If both suffix and clear button mode is provided,
                    /// suffix will override the clear button.
                    suffix: Text('SUFFIX'),
                    // clearButtonMode: OverlayVisibilityMode.always,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 20),
                const SizedBox(
                  width: 300.0,
                  child: MacosTextField(
                    enabled: false,
                    prefix: MacosIcon(CupertinoIcons.search),
                    placeholder: 'Disabled field',

                    /// If both suffix and clear button mode is provided,
                    /// suffix will override the clear button.
                    // suffix: Text('SUFFIX'),
                    clearButtonMode: OverlayVisibilityMode.always,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300.0,
                  child: MacosSearchField(
                    results: countries.map((e) => SearchResultItem(e)).toList(),
                    placeholder: 'Search for a country...',
                    onResultSelected: (resultItem) {
                      // Retrieve the user-selected search suggestion via its
                      // searchKey property.
                      debugPrint(resultItem.searchKey);
                    },
                    onChanged: (searchQuery) => debugPrint(searchQuery),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300.0,
                  // Example of search field with custom SearchResultItems
                  // and height.
                  child: MacosSearchField(
                    results: actionResults,
                    resultHeight: 40.0,
                    emptyWidget: const Center(
                        child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("No action found!"),
                    )),
                    placeholder: 'Search for an action...',
                    onResultSelected: (resultItem) {
                      // Retrieve the user-selected search suggestion via its
                      // searchKey property.
                      debugPrint(resultItem.searchKey);
                    },
                    onChanged: (searchQuery) => debugPrint(searchQuery),
                  ),
                ),
              ],
            ),
          );
        }),
        ResizablePane(
          minWidth: 180,
          startWidth: 200,
          windowBreakpoint: 800,
          resizableSide: ResizableSide.left,
          builder: (_, __) {
            return const Center(
              child: Text('Resizable Pane'),
            );
          },
        ),
      ],
    );
  }
}

const countries = [
  "Afghanistan",
  "Albania",
  "Algeria",
  "Andorra",
  "Angola",
  "Anguilla",
  "Antigua and Barbuda",
  "Argentina",
  "Armenia",
  "Aruba",
  "Australia",
  "Austria",
  "Azerbaijan",
  "Bahamas",
  "Bahrain",
  "Bangladesh",
  "Barbados",
  "Belarus",
  "Belgium",
  "Belize",
  "Benin",
  "Bermuda",
  "Bhutan",
  "Bolivia",
  "Bosnia and Herzegovina",
  "Botswana",
  "Brazil",
  "British Virgin Islands",
  "Brunei",
  "Bulgaria",
  "Burkina Faso",
  "Burundi",
  "Cambodia",
  "Cameroon",
  "Cape Verde",
  "Cayman Islands",
  "Chad",
  "Chile",
  "China",
  "Colombia",
  "Congo",
  "Cook Islands",
  "Costa Rica",
  "Cote D Ivoire",
  "Croatia",
  "Cruise Ship",
  "Cuba",
  "Cyprus",
  "Czech Republic",
  "Denmark",
  "Djibouti",
  "Dominica",
  "Dominican Republic",
  "Ecuador",
  "Egypt",
  "El Salvador",
  "Equatorial Guinea",
  "Estonia",
  "Ethiopia",
  "Falkland Islands",
  "Faroe Islands",
  "Fiji",
  "Finland",
  "France",
  "French Polynesia",
  "French West Indies",
  "Gabon",
  "Gambia",
  "Georgia",
  "Germany",
  "Ghana",
  "Gibraltar",
  "Greece",
  "Greenland",
  "Grenada",
  "Guam",
  "Guatemala",
  "Guernsey",
  "Guinea",
  "Guinea Bissau",
  "Guyana",
  "Haiti",
  "Honduras",
  "Hong Kong",
  "Hungary",
  "Iceland",
  "India",
  "Indonesia",
  "Iran",
  "Iraq",
  "Ireland",
  "Isle of Man",
  "Israel",
  "Italy",
  "Jamaica",
  "Japan",
  "Jersey",
  "Jordan",
  "Kazakhstan",
  "Kenya",
  "Kuwait",
  "Kyrgyz Republic",
  "Laos",
  "Latvia",
  "Lebanon",
  "Lesotho",
  "Liberia",
  "Libya",
  "Liechtenstein",
  "Lithuania",
  "Luxembourg",
  "Macau",
  "Macedonia",
  "Madagascar",
  "Malawi",
  "Malaysia",
  "Maldives",
  "Mali",
  "Malta",
  "Mauritania",
  "Mauritius",
  "Mexico",
  "Moldova",
  "Monaco",
  "Mongolia",
  "Montenegro",
  "Montserrat",
  "Morocco",
  "Mozambique",
  "Namibia",
  "Nepal",
  "Netherlands",
  "Netherlands Antilles",
  "New Caledonia",
  "New Zealand",
  "Nicaragua",
  "Niger",
  "Nigeria",
  "Norway",
  "Oman",
  "Pakistan",
  "Palestine",
  "Panama",
  "Papua New Guinea",
  "Paraguay",
  "Peru",
  "Philippines",
  "Poland",
  "Portugal",
  "Puerto Rico",
  "Qatar",
  "Reunion",
  "Romania",
  "Russia",
  "Rwanda",
  "Saint Pierre and Miquelon",
  "Samoa",
  "San Marino",
  "Satellite",
  "Saudi Arabia",
  "Senegal",
  "Serbia",
  "Seychelles",
  "Sierra Leone",
  "Singapore",
  "Slovakia",
  "Slovenia",
  "South Africa",
  "South Korea",
  "Spain",
  "Sri Lanka",
  "St Kitts and Nevis",
  "St Lucia",
  "St Vincent",
  "St. Lucia",
  "Sudan",
  "Suriname",
  "Swaziland",
  "Sweden",
  "Switzerland",
  "Syria",
  "Taiwan",
  "Tajikistan",
  "Tanzania",
  "Thailand",
  "Timor L'Este",
  "Togo",
  "Tonga",
  "Trinidad and Tobago",
  "Tunisia",
  "Turkey",
  "Turkmenistan",
  "Turks and Caicos",
  "Uganda",
  "Ukraine",
  "United Arab Emirates",
  "United Kingdom",
  "Uruguay",
  "Uzbekistan",
  "Venezuela",
  "Vietnam",
  "Virgin Islands (US)",
  "Yemen",
  "Zambia",
  "Zimbabwe"
];

var actionResults = [
  SearchResultItem(
    "Build project",
    child: Row(
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: MacosIcon(CupertinoIcons.hammer),
        ),
        Text("Build project"),
      ],
    ),
    onSelected: () => debugPrint("Will build the project"),
  ),
  SearchResultItem(
    "Debug project",
    child: Row(
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: MacosIcon(CupertinoIcons.tickets),
        ),
        Text("Debug project"),
      ],
    ),
    onSelected: () => debugPrint("Will debug the project"),
  ),
  SearchResultItem(
    "Open containing folder",
    child: Row(
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: MacosIcon(CupertinoIcons.folder),
        ),
        Text("Open containing folder"),
      ],
    ),
    onSelected: () => debugPrint("Will open containing folder"),
  ),
];
