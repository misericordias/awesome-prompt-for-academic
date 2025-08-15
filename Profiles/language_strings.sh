#!/opt/homebrew/bin/bash

# Language Strings for Interface Localization
# Supports the top 10 most used languages globally based on prompt availability

# Function to get localized string
get_string() {
    local key="$1"
    local lang="${2:-EN}"
    
    case "$lang" in
        "EN") # English
            case "$key" in
                "MAIN_TITLE") echo "🎓 AWESOME ACADEMIC PROMPTS TOOLKIT 🎓" ;;
                "MAIN_SUBTITLE") echo "Your Complete Academic AI Prompt Management" ;;
                "MAIN_SUBTITLE2") echo "Command Center" ;;
                "AVAILABLE_TOOLS") echo "📋 Available Tools:" ;;
                "ADD_PROMPT") echo "📝 Add New Prompt" ;;
                "ADD_PROMPT_DESC") echo "Interactive tool to add academic prompts with validation" ;;
                "SEARCH_PROMPTS") echo "🔍 Search Prompts" ;;
                "SEARCH_PROMPTS_DESC") echo "Find prompts by keywords, categories, or tags" ;;
                "MANAGE_CATEGORIES") echo "🏷️  Manage Categories" ;;
                "MANAGE_CATEGORIES_DESC") echo "Add/manage Research Areas and Prompt Categories" ;;
                "REPO_STATS") echo "📊 Repository Statistics" ;;
                "REPO_STATS_DESC") echo "View collection statistics and overview" ;;
                "TRANSLATION_TOOLS") echo "🌍 Translation Tools" ;;
                "TRANSLATION_TOOLS_DESC") echo "Manage multilingual translations and consistency" ;;
                "DOCUMENTATION") echo "📚 Documentation" ;;
                "DOCUMENTATION_DESC") echo "Access help and documentation" ;;
                "SETTINGS") echo "⚙️  Settings" ;;
                "SETTINGS_DESC") echo "Manage user preferences and configuration" ;;
                "EXIT") echo "🚪 Exit" ;;
                "SELECT_OPTION") echo "Select option" ;;
                "BACK_TO_MENU") echo "🔙 Back to Main Menu" ;;
                "INTERFACE_LANGUAGE") echo "🌐 Interface Language" ;;
                "INTERFACE_LANGUAGE_DESC") echo "Change interface display language" ;;
                # Search Menu
                "SEARCH_MENU_TITLE") echo "🔍 Search Prompts" ;;
                "INTERACTIVE_SEARCH") echo "🔍 Interactive Search" ;;
                "QUICK_KEYWORD_SEARCH") echo "📝 Quick Keyword Search" ;;
                "BROWSE_BY_CATEGORY") echo "📂 Browse by Category" ;;
                "SEARCH_BY_TAG") echo "🏷️ Search by Tag" ;;
                "LIST_ALL_CATEGORIES") echo "📋 List All Categories" ;;
                "COPY_PROMPT_CLIPBOARD") echo "📋 Copy Prompt to Clipboard" ;;
                # Translation Menu
                "TRANSLATION_MENU_TITLE") echo "🌍 Translation Tools & Multilingual Management" ;;
                "TRANSLATION_STATUS") echo "📊 Translation Status" ;;
                "VERIFY_CONSISTENCY") echo "🔍 Verify Consistency" ;;
                "COUNT_PROMPTS") echo "📈 Count Prompts" ;;
                "LANGUAGE_OVERVIEW") echo "🌐 Language Overview" ;;
                # Documentation Menu
                "DOC_MENU_TITLE") echo "📚 Documentation & Help" ;;
                "QUICK_START_COMMON") echo "📋 Quick Start & Common Tasks" ;;
                "TOOLS_OVERVIEW") echo "🛠️ Tools Overview & Features" ;;
                "REPO_STRUCTURE") echo "📁 Repository Structure & Format" ;;
                "COMPLETE_DOCS") echo "📖 Complete Documentation (README.md)" ;;
                "COMMAND_HELP") echo "🔧 Command Help & Examples" ;;
                "LANGUAGES_CATEGORIES") echo "🌍 Languages & Categories Guide" ;;
                "SMART_NAVIGATION") echo "🎭 Smart Navigation Guide" ;;
                # Statistics Menu
                "STATS_MENU_TITLE") echo "📊 Repository Statistics" ;;
                "RETURN_TO_MAIN") echo "🔙 Return to Main Menu" ;;
                "VIEW_STATS_AGAIN") echo "📊 View Statistics Again" ;;
                # Profile Menu
                "PROFILE_MENU_TITLE") echo "⚙️ User Profile Management" ;;
                "VIEW_CURRENT_PROFILE") echo "📋 View Current Profile" ;;
                "EDIT_SETTINGS") echo "✏️ Edit Settings" ;;
                "RESET_TO_DEFAULTS") echo "🔄 Reset to Defaults" ;;
                "OPEN_PROFILE_FILE") echo "📁 Open Profile File" ;;
                # Documentation sub-functions
                "QUICK_START_TITLE") echo "📋 Quick Start & Common Tasks" ;;
                "TOOLS_OVERVIEW_TITLE") echo "🛠️ Tools Overview & Features" ;;
                "STRUCTURE_FORMAT_TITLE") echo "📁 Repository Structure & Format" ;;
                "COMMAND_HELP_TITLE") echo "🔧 Command Help & Examples" ;;
                "LANGUAGES_GUIDE_TITLE") echo "🌍 Languages & Categories Guide" ;;
                "SMART_NAV_TITLE") echo "🎭 Smart Navigation Guide" ;;
                # Profile Management sub-functions
                "CURRENT_PROFILE_TITLE") echo "📋 Current User Profile Settings" ;;
                "EDIT_SETTINGS_TITLE") echo "✏️ Edit Profile Settings" ;;
                "DISPLAY_SETTINGS_TITLE") echo "🔧 Display Settings" ;;
                "INTERFACE_SETTINGS_TITLE") echo "🎨 Interface Settings" ;;
                "SEARCH_SETTINGS_TITLE") echo "🔍 Search Settings" ;;
                "TOOL_SETTINGS_TITLE") echo "🛠️ Tool Settings" ;;
                "RESET_DEFAULTS_TITLE") echo "🔄 Reset to Default Settings" ;;
                "INTERFACE_LANG_SELECTION") echo "🌐 Interface Language Selection" ;;
                # Common UI elements
                "CURRENT_SETTINGS") echo "Current Settings:" ;;
                "PRESS_ENTER_CONTINUE") echo "Press Enter to continue..." ;;
                "PRESS_ENTER_RETURN") echo "Press Enter or type 'q' to return to" ;;
                "INVALID_CHOICE") echo "Invalid choice. Please select" ;;
                "BACK_TO_EDIT_MENU") echo "🔙 Back to Edit Menu" ;;
                "BACK_TO_PROFILE_MENU") echo "🔙 Back to Profile Menu" ;;
                "YES_NO_PROMPT") echo "(y/n)" ;;
                "SELECT_LANGUAGE") echo "Select your preferred interface language:" ;;
                "CHANGES_TAKE_EFFECT") echo "Changes will take effect after restarting the application." ;;
                *) echo "$key" ;;
            esac
            ;;
        "ZH") # Chinese (Simplified)
            case "$key" in
                "MAIN_TITLE") echo "🎓 超棒学术提示工具包 🎓" ;;
                "MAIN_SUBTITLE") echo "您完整的学术AI提示管理" ;;
                "MAIN_SUBTITLE2") echo "命令中心" ;;
                "AVAILABLE_TOOLS") echo "📋 可用工具:" ;;
                "ADD_PROMPT") echo "📝 添加新提示" ;;
                "ADD_PROMPT_DESC") echo "带验证功能的交互式学术提示添加工具" ;;
                "SEARCH_PROMPTS") echo "🔍 搜索提示" ;;
                "SEARCH_PROMPTS_DESC") echo "通过关键词、类别或标签查找提示" ;;
                "MANAGE_CATEGORIES") echo "🏷️  管理类别" ;;
                "MANAGE_CATEGORIES_DESC") echo "添加/管理研究领域和提示类别" ;;
                "REPO_STATS") echo "📊 仓库统计" ;;
                "REPO_STATS_DESC") echo "查看收集统计和概览" ;;
                "TRANSLATION_TOOLS") echo "🌍 翻译工具" ;;
                "TRANSLATION_TOOLS_DESC") echo "管理多语言翻译和一致性" ;;
                "DOCUMENTATION") echo "📚 文档" ;;
                "DOCUMENTATION_DESC") echo "访问帮助和文档" ;;
                "SETTINGS") echo "⚙️  设置" ;;
                "SETTINGS_DESC") echo "管理用户偏好和配置" ;;
                "EXIT") echo "🚪 退出" ;;
                "SELECT_OPTION") echo "选择选项" ;;
                "BACK_TO_MENU") echo "🔙 返回主菜单" ;;
                "INTERFACE_LANGUAGE") echo "🌐 界面语言" ;;
                "INTERFACE_LANGUAGE_DESC") echo "更改界面显示语言" ;;
                # Search Menu
                "SEARCH_MENU_TITLE") echo "🔍 搜索提示" ;;
                "INTERACTIVE_SEARCH") echo "🔍 交互式搜索" ;;
                "QUICK_KEYWORD_SEARCH") echo "📝 快速关键词搜索" ;;
                "BROWSE_BY_CATEGORY") echo "📂 按类别浏览" ;;
                "SEARCH_BY_TAG") echo "🏷️ 按标签搜索" ;;
                "LIST_ALL_CATEGORIES") echo "📋 列出所有类别" ;;
                "COPY_PROMPT_CLIPBOARD") echo "📋 复制提示到剪贴板" ;;
                # Translation Menu
                "TRANSLATION_MENU_TITLE") echo "🌍 翻译工具与多语言管理" ;;
                "TRANSLATION_STATUS") echo "📊 翻译状态" ;;
                "VERIFY_CONSISTENCY") echo "🔍 验证一致性" ;;
                "COUNT_PROMPTS") echo "📈 计算提示数量" ;;
                "LANGUAGE_OVERVIEW") echo "🌐 语言概览" ;;
                # Documentation Menu
                "DOC_MENU_TITLE") echo "📚 文档与帮助" ;;
                "QUICK_START_COMMON") echo "📋 快速开始与常用任务" ;;
                "TOOLS_OVERVIEW") echo "🛠️ 工具概览与功能" ;;
                "REPO_STRUCTURE") echo "📁 仓库结构与格式" ;;
                "COMPLETE_DOCS") echo "📖 完整文档 (README.md)" ;;
                "COMMAND_HELP") echo "🔧 命令帮助与示例" ;;
                "LANGUAGES_CATEGORIES") echo "🌍 语言与类别指南" ;;
                "SMART_NAVIGATION") echo "🎭 智能导航指南" ;;
                # Statistics Menu
                "STATS_MENU_TITLE") echo "📊 仓库统计" ;;
                "RETURN_TO_MAIN") echo "🔙 返回主菜单" ;;
                "VIEW_STATS_AGAIN") echo "📊 再次查看统计" ;;
                # Profile Menu
                "PROFILE_MENU_TITLE") echo "⚙️ 用户配置文件管理" ;;
                "VIEW_CURRENT_PROFILE") echo "📋 查看当前配置文件" ;;
                "EDIT_SETTINGS") echo "✏️ 编辑设置" ;;
                "RESET_TO_DEFAULTS") echo "🔄 重置为默认" ;;
                "OPEN_PROFILE_FILE") echo "📁 打开配置文件" ;;
                # Documentation sub-functions
                "QUICK_START_TITLE") echo "📋 快速开始与常用任务" ;;
                "TOOLS_OVERVIEW_TITLE") echo "🛠️ 工具概览与功能" ;;
                "STRUCTURE_FORMAT_TITLE") echo "📁 仓库结构与格式" ;;
                "COMMAND_HELP_TITLE") echo "🔧 命令帮助与示例" ;;
                "LANGUAGES_GUIDE_TITLE") echo "🌍 语言与类别指南" ;;
                "SMART_NAV_TITLE") echo "🎭 智能导航指南" ;;
                # Profile Management sub-functions
                "CURRENT_PROFILE_TITLE") echo "📋 当前用户配置文件设置" ;;
                "EDIT_SETTINGS_TITLE") echo "✏️ 编辑配置文件设置" ;;
                "DISPLAY_SETTINGS_TITLE") echo "🔧 显示设置" ;;
                "INTERFACE_SETTINGS_TITLE") echo "🎨 界面设置" ;;
                "SEARCH_SETTINGS_TITLE") echo "🔍 搜索设置" ;;
                "TOOL_SETTINGS_TITLE") echo "🛠️ 工具设置" ;;
                "RESET_DEFAULTS_TITLE") echo "🔄 重置为默认设置" ;;
                "INTERFACE_LANG_SELECTION") echo "🌐 界面语言选择" ;;
                # Common UI elements
                "CURRENT_SETTINGS") echo "当前设置:" ;;
                "PRESS_ENTER_CONTINUE") echo "按回车键继续..." ;;
                "PRESS_ENTER_RETURN") echo "按回车键或输入 'q' 返回到" ;;
                "INVALID_CHOICE") echo "无效选择。请选择" ;;
                "BACK_TO_EDIT_MENU") echo "🔙 返回编辑菜单" ;;
                "BACK_TO_PROFILE_MENU") echo "🔙 返回配置文件菜单" ;;
                "YES_NO_PROMPT") echo "(y/n)" ;;
                "SELECT_LANGUAGE") echo "选择您的首选界面语言:" ;;
                "CHANGES_TAKE_EFFECT") echo "更改将在重新启动应用程序后生效。" ;;
                *) echo "$key" ;;
            esac
            ;;
        "ES") # Spanish
            case "$key" in
                "MAIN_TITLE") echo "🎓 TOOLKIT DE PROMPTS ACADÉMICOS IMPRESIONANTES 🎓" ;;
                "MAIN_SUBTITLE") echo "Su Centro de Gestión Completo de Prompts de IA Académica" ;;
                "MAIN_SUBTITLE2") echo "Centro de Comando" ;;
                "AVAILABLE_TOOLS") echo "📋 Herramientas Disponibles:" ;;
                "ADD_PROMPT") echo "📝 Agregar Nuevo Prompt" ;;
                "ADD_PROMPT_DESC") echo "Herramienta interactiva para agregar prompts académicos con validación" ;;
                "SEARCH_PROMPTS") echo "🔍 Buscar Prompts" ;;
                "SEARCH_PROMPTS_DESC") echo "Encuentra prompts por palabras clave, categorías o etiquetas" ;;
                "MANAGE_CATEGORIES") echo "🏷️  Gestionar Categorías" ;;
                "MANAGE_CATEGORIES_DESC") echo "Agregar/gestionar Áreas de Investigación y Categorías de Prompts" ;;
                "REPO_STATS") echo "📊 Estadísticas del Repositorio" ;;
                "REPO_STATS_DESC") echo "Ver estadísticas de la colección y resumen" ;;
                "TRANSLATION_TOOLS") echo "🌍 Herramientas de Traducción" ;;
                "TRANSLATION_TOOLS_DESC") echo "Gestionar traducciones multilingües y consistencia" ;;
                "DOCUMENTATION") echo "📚 Documentación" ;;
                "DOCUMENTATION_DESC") echo "Acceder a ayuda y documentación" ;;
                "SETTINGS") echo "⚙️  Configuración" ;;
                "SETTINGS_DESC") echo "Gestionar preferencias de usuario y configuración" ;;
                "EXIT") echo "🚪 Salir" ;;
                "SELECT_OPTION") echo "Seleccionar opción" ;;
                "BACK_TO_MENU") echo "🔙 Volver al Menú Principal" ;;
                "INTERFACE_LANGUAGE") echo "🌐 Idioma de Interfaz" ;;
                "INTERFACE_LANGUAGE_DESC") echo "Cambiar idioma de visualización de interfaz" ;;
                *) echo "$key" ;;
            esac
            ;;
        "HI") # Hindi
            case "$key" in
                "MAIN_TITLE") echo "🎓 अद्भुत शैक्षणिक प्रॉम्प्ट टूलकिट 🎓" ;;
                "MAIN_SUBTITLE") echo "आपका पूर्ण शैक्षणिक AI प्रॉम्प्ट प्रबंधन" ;;
                "MAIN_SUBTITLE2") echo "कमांड सेंटर" ;;
                "AVAILABLE_TOOLS") echo "📋 उपलब्ध उपकरण:" ;;
                "ADD_PROMPT") echo "📝 नया प्रॉम्प्ट जोड़ें" ;;
                "ADD_PROMPT_DESC") echo "सत्यापन के साथ शैक्षणिक प्रॉम्प्ट जोड़ने के लिए इंटरैक्टिव उपकरण" ;;
                "SEARCH_PROMPTS") echo "🔍 प्रॉम्प्ट खोजें" ;;
                "SEARCH_PROMPTS_DESC") echo "कीवर्ड, श्रेणियों या टैग द्वारा प्रॉम्प्ट खोजें" ;;
                "MANAGE_CATEGORIES") echo "🏷️  श्रेणियां प्रबंधित करें" ;;
                "MANAGE_CATEGORIES_DESC") echo "अनुसंधान क्षेत्र और प्रॉम्प्ट श्रेणियां जोड़ें/प्रबंधित करें" ;;
                "REPO_STATS") echo "📊 रिपॉजिटरी आंकड़े" ;;
                "REPO_STATS_DESC") echo "संग्रह आंकड़े और अवलोकन देखें" ;;
                "TRANSLATION_TOOLS") echo "🌍 अनुवाद उपकरण" ;;
                "TRANSLATION_TOOLS_DESC") echo "बहुभाषी अनुवाद और संगति प्रबंधित करें" ;;
                "DOCUMENTATION") echo "📚 दस्तावेज़ीकरण" ;;
                "DOCUMENTATION_DESC") echo "सहायता और दस्तावेज़ीकरण तक पहुंचें" ;;
                "SETTINGS") echo "⚙️  सेटिंग्स" ;;
                "SETTINGS_DESC") echo "उपयोगकर्ता प्राथमिकताएं और कॉन्फ़िगरेशन प्रबंधित करें" ;;
                "EXIT") echo "🚪 निकास" ;;
                "SELECT_OPTION") echo "विकल्प चुनें" ;;
                "BACK_TO_MENU") echo "🔙 मुख्य मेनू पर वापस" ;;
                "INTERFACE_LANGUAGE") echo "🌐 इंटरफ़ेस भाषा" ;;
                "INTERFACE_LANGUAGE_DESC") echo "इंटरफ़ेस प्रदर्शन भाषा बदलें" ;;
                *) echo "$key" ;;
            esac
            ;;
        "AR") # Arabic
            case "$key" in
                "MAIN_TITLE") echo "🎓 مجموعة أدوات المطالبات الأكاديمية الرائعة 🎓" ;;
                "MAIN_SUBTITLE") echo "مركز إدارة مطالبات الذكاء الاصطناعي الأكاديمي الكامل" ;;
                "MAIN_SUBTITLE2") echo "مركز القيادة" ;;
                "AVAILABLE_TOOLS") echo "📋 الأدوات المتاحة:" ;;
                "ADD_PROMPT") echo "📝 إضافة مطالبة جديدة" ;;
                "ADD_PROMPT_DESC") echo "أداة تفاعلية لإضافة مطالبات أكاديمية مع التحقق" ;;
                "SEARCH_PROMPTS") echo "🔍 البحث في المطالبات" ;;
                "SEARCH_PROMPTS_DESC") echo "العثور على المطالبات بالكلمات المفتاحية أو الفئات أو العلامات" ;;
                "MANAGE_CATEGORIES") echo "🏷️  إدارة الفئات" ;;
                "MANAGE_CATEGORIES_DESC") echo "إضافة/إدارة مجالات البحث وفئات المطالبات" ;;
                "REPO_STATS") echo "📊 إحصائيات المستودع" ;;
                "REPO_STATS_DESC") echo "عرض إحصائيات المجموعة والنظرة العامة" ;;
                "TRANSLATION_TOOLS") echo "🌍 أدوات الترجمة" ;;
                "TRANSLATION_TOOLS_DESC") echo "إدارة الترجمات متعددة اللغات والاتساق" ;;
                "DOCUMENTATION") echo "📚 التوثيق" ;;
                "DOCUMENTATION_DESC") echo "الوصول إلى المساعدة والتوثيق" ;;
                "SETTINGS") echo "⚙️  الإعدادات" ;;
                "SETTINGS_DESC") echo "إدارة تفضيلات المستخدم والتكوين" ;;
                "EXIT") echo "🚪 خروج" ;;
                "SELECT_OPTION") echo "اختر الخيار" ;;
                "BACK_TO_MENU") echo "🔙 العودة إلى القائمة الرئيسية" ;;
                "INTERFACE_LANGUAGE") echo "🌐 لغة الواجهة" ;;
                "INTERFACE_LANGUAGE_DESC") echo "تغيير لغة عرض الواجهة" ;;
                *) echo "$key" ;;
            esac
            ;;
        "PT") # Portuguese
            case "$key" in
                "MAIN_TITLE") echo "🎓 TOOLKIT DE PROMPTS ACADÊMICOS FANTÁSTICOS 🎓" ;;
                "MAIN_SUBTITLE") echo "Seu Centro Completo de Gerenciamento de Prompts de IA Acadêmica" ;;
                "MAIN_SUBTITLE2") echo "Centro de Comando" ;;
                "AVAILABLE_TOOLS") echo "📋 Ferramentas Disponíveis:" ;;
                "ADD_PROMPT") echo "📝 Adicionar Novo Prompt" ;;
                "ADD_PROMPT_DESC") echo "Ferramenta interativa para adicionar prompts acadêmicos com validação" ;;
                "SEARCH_PROMPTS") echo "🔍 Pesquisar Prompts" ;;
                "SEARCH_PROMPTS_DESC") echo "Encontrar prompts por palavras-chave, categorias ou tags" ;;
                "MANAGE_CATEGORIES") echo "🏷️  Gerenciar Categorias" ;;
                "MANAGE_CATEGORIES_DESC") echo "Adicionar/gerenciar Áreas de Pesquisa e Categorias de Prompts" ;;
                "REPO_STATS") echo "📊 Estatísticas do Repositório" ;;
                "REPO_STATS_DESC") echo "Ver estatísticas da coleção e visão geral" ;;
                "TRANSLATION_TOOLS") echo "🌍 Ferramentas de Tradução" ;;
                "TRANSLATION_TOOLS_DESC") echo "Gerenciar traduções multilíngues e consistência" ;;
                "DOCUMENTATION") echo "📚 Documentação" ;;
                "DOCUMENTATION_DESC") echo "Acessar ajuda e documentação" ;;
                "SETTINGS") echo "⚙️  Configurações" ;;
                "SETTINGS_DESC") echo "Gerenciar preferências do usuário e configuração" ;;
                "EXIT") echo "🚪 Sair" ;;
                "SELECT_OPTION") echo "Selecionar opção" ;;
                "BACK_TO_MENU") echo "🔙 Voltar ao Menu Principal" ;;
                "INTERFACE_LANGUAGE") echo "🌐 Idioma da Interface" ;;
                "INTERFACE_LANGUAGE_DESC") echo "Alterar idioma de exibição da interface" ;;
                *) echo "$key" ;;
            esac
            ;;
        "RU") # Russian
            case "$key" in
                "MAIN_TITLE") echo "🎓 ПОТРЯСАЮЩИЙ НАБОР АКАДЕМИЧЕСКИХ ПРОМПТОВ 🎓" ;;
                "MAIN_SUBTITLE") echo "Ваш Полный Центр Управления Академическими ИИ Промптами" ;;
                "MAIN_SUBTITLE2") echo "Командный Центр" ;;
                "AVAILABLE_TOOLS") echo "📋 Доступные Инструменты:" ;;
                "ADD_PROMPT") echo "📝 Добавить Новый Промпт" ;;
                "ADD_PROMPT_DESC") echo "Интерактивный инструмент для добавления академических промптов с проверкой" ;;
                "SEARCH_PROMPTS") echo "🔍 Поиск Промптов" ;;
                "SEARCH_PROMPTS_DESC") echo "Найти промпты по ключевым словам, категориям или тегам" ;;
                "MANAGE_CATEGORIES") echo "🏷️  Управление Категориями" ;;
                "MANAGE_CATEGORIES_DESC") echo "Добавить/управлять Областями Исследований и Категориями Промптов" ;;
                "REPO_STATS") echo "📊 Статистика Репозитория" ;;
                "REPO_STATS_DESC") echo "Просмотр статистики коллекции и обзора" ;;
                "TRANSLATION_TOOLS") echo "🌍 Инструменты Перевода" ;;
                "TRANSLATION_TOOLS_DESC") echo "Управление многоязычными переводами и согласованностью" ;;
                "DOCUMENTATION") echo "📚 Документация" ;;
                "DOCUMENTATION_DESC") echo "Доступ к справке и документации" ;;
                "SETTINGS") echo "⚙️  Настройки" ;;
                "SETTINGS_DESC") echo "Управление пользовательскими предпочтениями и конфигурацией" ;;
                "EXIT") echo "🚪 Выход" ;;
                "SELECT_OPTION") echo "Выберите опцию" ;;
                "BACK_TO_MENU") echo "🔙 Назад в Главное Меню" ;;
                "INTERFACE_LANGUAGE") echo "🌐 Язык Интерфейса" ;;
                "INTERFACE_LANGUAGE_DESC") echo "Изменить язык отображения интерфейса" ;;
                *) echo "$key" ;;
            esac
            ;;
        "JP") # Japanese
            case "$key" in
                "MAIN_TITLE") echo "🎓 素晴らしい学術プロンプトツールキット 🎓" ;;
                "MAIN_SUBTITLE") echo "完全な学術AIプロンプト管理" ;;
                "MAIN_SUBTITLE2") echo "コマンドセンター" ;;
                "AVAILABLE_TOOLS") echo "📋 利用可能なツール:" ;;
                "ADD_PROMPT") echo "📝 新しいプロンプトを追加" ;;
                "ADD_PROMPT_DESC") echo "検証機能付きの学術プロンプト追加インタラクティブツール" ;;
                "SEARCH_PROMPTS") echo "🔍 プロンプト検索" ;;
                "SEARCH_PROMPTS_DESC") echo "キーワード、カテゴリー、またはタグでプロンプトを検索" ;;
                "MANAGE_CATEGORIES") echo "🏷️  カテゴリー管理" ;;
                "MANAGE_CATEGORIES_DESC") echo "研究分野とプロンプトカテゴリーの追加/管理" ;;
                "REPO_STATS") echo "📊 リポジトリ統計" ;;
                "REPO_STATS_DESC") echo "コレクション統計と概要を表示" ;;
                "TRANSLATION_TOOLS") echo "🌍 翻訳ツール" ;;
                "TRANSLATION_TOOLS_DESC") echo "多言語翻訳と一貫性の管理" ;;
                "DOCUMENTATION") echo "📚 ドキュメント" ;;
                "DOCUMENTATION_DESC") echo "ヘルプとドキュメントへのアクセス" ;;
                "SETTINGS") echo "⚙️  設定" ;;
                "SETTINGS_DESC") echo "ユーザー設定と構成の管理" ;;
                "EXIT") echo "🚪 終了" ;;
                "SELECT_OPTION") echo "オプションを選択" ;;
                "BACK_TO_MENU") echo "🔙 メインメニューに戻る" ;;
                "INTERFACE_LANGUAGE") echo "🌐 インターフェース言語" ;;
                "INTERFACE_LANGUAGE_DESC") echo "インターフェース表示言語を変更" ;;
                *) echo "$key" ;;
            esac
            ;;
        "DE") # German
            case "$key" in
                "MAIN_TITLE") echo "🎓 FANTASTISCHES AKADEMISCHES PROMPT-TOOLKIT 🎓" ;;
                "MAIN_SUBTITLE") echo "Ihr Komplettes Akademisches KI-Prompt-Management" ;;
                "MAIN_SUBTITLE2") echo "Kommandozentrale" ;;
                "AVAILABLE_TOOLS") echo "📋 Verfügbare Tools:" ;;
                "ADD_PROMPT") echo "📝 Neuen Prompt Hinzufügen" ;;
                "ADD_PROMPT_DESC") echo "Interaktives Tool zum Hinzufügen akademischer Prompts mit Validierung" ;;
                "SEARCH_PROMPTS") echo "🔍 Prompts Suchen" ;;
                "SEARCH_PROMPTS_DESC") echo "Prompts nach Stichwörtern, Kategorien oder Tags finden" ;;
                "MANAGE_CATEGORIES") echo "🏷️  Kategorien Verwalten" ;;
                "MANAGE_CATEGORIES_DESC") echo "Forschungsbereiche und Prompt-Kategorien hinzufügen/verwalten" ;;
                "REPO_STATS") echo "📊 Repository-Statistiken" ;;
                "REPO_STATS_DESC") echo "Sammlungsstatistiken und Übersicht anzeigen" ;;
                "TRANSLATION_TOOLS") echo "🌍 Übersetzungstools" ;;
                "TRANSLATION_TOOLS_DESC") echo "Mehrsprachige Übersetzungen und Konsistenz verwalten" ;;
                "DOCUMENTATION") echo "📚 Dokumentation" ;;
                "DOCUMENTATION_DESC") echo "Auf Hilfe und Dokumentation zugreifen" ;;
                "SETTINGS") echo "⚙️  Einstellungen" ;;
                "SETTINGS_DESC") echo "Benutzereinstellungen und Konfiguration verwalten" ;;
                "EXIT") echo "🚪 Beenden" ;;
                "SELECT_OPTION") echo "Option auswählen" ;;
                "BACK_TO_MENU") echo "🔙 Zurück zum Hauptmenü" ;;
                "INTERFACE_LANGUAGE") echo "🌐 Oberflächensprache" ;;
                "INTERFACE_LANGUAGE_DESC") echo "Anzeigesprache der Oberfläche ändern" ;;
                *) echo "$key" ;;
            esac
            ;;
        "FR") # French
            case "$key" in
                "MAIN_TITLE") echo "🎓 BOÎTE À OUTILS DE PROMPTS ACADÉMIQUES FANTASTIQUES 🎓" ;;
                "MAIN_SUBTITLE") echo "Votre Centre Complet de Gestion de Prompts IA Académiques" ;;
                "MAIN_SUBTITLE2") echo "Centre de Commande" ;;
                "AVAILABLE_TOOLS") echo "📋 Outils Disponibles:" ;;
                "ADD_PROMPT") echo "📝 Ajouter Nouveau Prompt" ;;
                "ADD_PROMPT_DESC") echo "Outil interactif pour ajouter des prompts académiques avec validation" ;;
                "SEARCH_PROMPTS") echo "🔍 Rechercher Prompts" ;;
                "SEARCH_PROMPTS_DESC") echo "Trouver des prompts par mots-clés, catégories ou tags" ;;
                "MANAGE_CATEGORIES") echo "🏷️  Gérer Catégories" ;;
                "MANAGE_CATEGORIES_DESC") echo "Ajouter/gérer Domaines de Recherche et Catégories de Prompts" ;;
                "REPO_STATS") echo "📊 Statistiques du Dépôt" ;;
                "REPO_STATS_DESC") echo "Voir statistiques de la collection et aperçu" ;;
                "TRANSLATION_TOOLS") echo "🌍 Outils de Traduction" ;;
                "TRANSLATION_TOOLS_DESC") echo "Gérer traductions multilingues et cohérence" ;;
                "DOCUMENTATION") echo "📚 Documentation" ;;
                "DOCUMENTATION_DESC") echo "Accéder à l'aide et à la documentation" ;;
                "SETTINGS") echo "⚙️  Paramètres" ;;
                "SETTINGS_DESC") echo "Gérer préférences utilisateur et configuration" ;;
                "EXIT") echo "🚪 Quitter" ;;
                "SELECT_OPTION") echo "Sélectionner option" ;;
                "BACK_TO_MENU") echo "🔙 Retour au Menu Principal" ;;
                "INTERFACE_LANGUAGE") echo "🌐 Langue d'Interface" ;;
                "INTERFACE_LANGUAGE_DESC") echo "Changer la langue d'affichage de l'interface" ;;
                *) echo "$key" ;;
            esac
            ;;
        *) # Default to English
            get_string "$key" "EN"
            ;;
    esac
}

# Function to get language name in native script
get_language_name() {
    local lang="$1"
    case "$lang" in
        "EN") echo "🇺🇸 English" ;;
        "ZH") echo "🇨🇳 中文" ;;
        "ES") echo "🇪🇸 Español" ;;
        "HI") echo "🇮🇳 हिन्दी" ;;
        "AR") echo "🇸🇦 العربية" ;;
        "PT") echo "🇵🇹 Português" ;;
        "RU") echo "🇷🇺 Русский" ;;
        "JP") echo "🇯🇵 日本語" ;;
        "DE") echo "🇩🇪 Deutsch" ;;
        "FR") echo "🇫🇷 Français" ;;
        *) echo "$lang" ;;
    esac
}

# Function to get supported interface languages
get_supported_languages() {
    echo "EN ZH ES HI AR PT RU JP DE FR"
}