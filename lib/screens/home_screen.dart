import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'upload_book_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? userData;
  bool isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final data = await AuthService().getCurrentUserData();

    if (mounted) {
      setState(() {
        userData = data;
        isLoadingUser = false;
      });
    }
  }

  Future<void> logout() async {
    await AuthService().logoutUser();
  }

  void showProfileDialog() {
    final fullName = userData?['fullName'] ?? 'Unknown';
    final email = userData?['email'] ?? 'Unknown';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 56,
                  color: Color(0xFF6366F1),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                fullName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color(0xFFE2E8F0),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Close Profile',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void openBooksDemo(String ageGroup, String fileType) {
    final List<String> books;

    if (ageGroup == '0-4') {
      books = ['The Very Hungry Caterpillar', 'Goodnight Moon'];
    } else if (ageGroup == '4-8') {
      books = ['Where the Wild Things Are', 'Charlotte’s Web'];
    } else {
      books = ['Percy Jackson & the Olympians', 'Harry Potter'];
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DemoBookListScreen(
          ageGroup: ageGroup,
          fileType: fileType,
          books: books,
        ),
      ),
    );
  }

  Widget buildAgeOption({
    required String ageGroup,
    required String fileType,
    required IconData icon,
    required Color color,
  }) {
    return InkWell(
      onTap: () => openBooksDemo(ageGroup, fileType),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 36, color: color),
              ),
              const SizedBox(height: 14),
              Text(
                'Ages $ageGroup',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  fileType.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fullName = userData?['fullName'] ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Slate 50
      appBar: AppBar(
        title: const Text('Children Books'),
        actions: [
          IconButton(
            onPressed: showProfileDialog,
            icon: const Icon(
              Icons.person_outline_rounded,
              color: Color(0xFF1E293B),
            ),
          ),
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout_rounded, color: Color(0xFF1E293B)),
          ),
        ],
      ),
      body: isLoadingUser
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF6366F1)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF6366F1,
                          ).withValues(alpha: 0.24),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName.isEmpty
                              ? 'Hello, Reader! 👋'
                              : 'Hello, $fullName! 👋',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Welcome back! Discover interactive stories, picture books, and early readers customized for every age level.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  const Text(
                    'Explore Categories',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 16),

                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.95,
                    children: [
                      buildAgeOption(
                        ageGroup: '0-4',
                        fileType: 'pdf',
                        icon: Icons.baby_changing_station,
                        color: const Color(0xFFEF4444), // Coral Red
                      ),
                      buildAgeOption(
                        ageGroup: '0-4',
                        fileType: 'word',
                        icon: Icons.toys_outlined,
                        color: const Color(0xFF3B82F6), // Blue
                      ),
                      buildAgeOption(
                        ageGroup: '4-8',
                        fileType: 'pdf',
                        icon: Icons.palette_outlined,
                        color: const Color(0xFFEC4899), // Pink
                      ),
                      buildAgeOption(
                        ageGroup: '4-8',
                        fileType: 'word',
                        icon: Icons.color_lens_outlined,
                        color: const Color(0xFF06B6D4), // Cyan
                      ),
                      buildAgeOption(
                        ageGroup: '8-12',
                        fileType: 'pdf',
                        icon: Icons.menu_book_rounded,
                        color: const Color(0xFF8B5CF6), // Purple
                      ),
                      buildAgeOption(
                        ageGroup: '8-12',
                        fileType: 'word',
                        icon: Icons.school_outlined,
                        color: const Color(0xFF10B981), // Emerald
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }
}

class DemoBookListScreen extends StatefulWidget {
  final String ageGroup;
  final String fileType;
  final List<String> books;

  const DemoBookListScreen({
    super.key,
    required this.ageGroup,
    required this.fileType,
    required this.books,
  });

  @override
  State<DemoBookListScreen> createState() => _DemoBookListScreenState();
}

class _DemoBookListScreenState extends State<DemoBookListScreen> {
  late List<String> booksList;
  final Set<String> downloadedBooks = {};

  @override
  void initState() {
    super.initState();
    booksList = List.from(widget.books);
  }

  void showDemoMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xFF1E293B),
      ),
    );
  }

  void getBook(String book) {
    setState(() {
      downloadedBooks.add(book);
    });

    showDemoMessage(
      'Demo: Downloading "$book" as ${widget.fileType.toUpperCase()}...',
    );
  }

  void openBook(String book) {
    showDemoMessage('Demo: Opening "$book" reading workspace.');
  }

  Future<void> uploadBook() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => UploadBookScreen(
          fileType: widget.fileType,
          ageGroup: widget.ageGroup,
        ),
      ),
    );

    if (result != null && result.trim().isNotEmpty) {
      setState(() {
        booksList.add(result.trim());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = widget.fileType == 'pdf'
        ? const Color(0xFFEF4444)
        : const Color(0xFF3B82F6);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text('Ages ${widget.ageGroup} Library'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: uploadBook,
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.upload_file_rounded),
        label: const Text(
          'Upload Book',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: themeColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.fileType == 'pdf'
                        ? Icons.picture_as_pdf_rounded
                        : Icons.description_rounded,
                    color: themeColor,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Viewing ${widget.fileType.toUpperCase()} formatted collection',
                    style: TextStyle(
                      color: themeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: ListView.builder(
                itemCount: booksList.length,
                padding: const EdgeInsets.only(bottom: 84),
                itemBuilder: (context, index) {
                  final book = booksList[index];
                  final isDownloaded = downloadedBooks.contains(book);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFF1F5F9),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF0F172A,
                          ).withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 68,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: widget.fileType == 'pdf'
                                    ? [
                                        const Color(0xFFFCA5A5),
                                        const Color(0xFFEF4444),
                                      ]
                                    : [
                                        const Color(0xFF93C5FD),
                                        const Color(0xFF3B82F6),
                                      ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: themeColor.withValues(alpha: 0.2),
                                  blurRadius: 6,
                                  offset: const Offset(1, 3),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.book_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1E293B),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.fileType.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: themeColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            height: 38,
                            child: isDownloaded
                                ? ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF10B981),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                      ),
                                    ),
                                    onPressed: () => openBook(book),
                                    icon: const Icon(
                                      Icons.open_in_new_rounded,
                                      size: 14,
                                    ),
                                    label: const Text(
                                      'OPEN',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  )
                                : OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: themeColor,
                                      side: BorderSide(
                                        color: themeColor.withValues(
                                          alpha: 0.5,
                                        ),
                                        width: 1.5,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                      ),
                                    ),
                                    onPressed: () => getBook(book),
                                    icon: const Icon(
                                      Icons.download_rounded,
                                      size: 14,
                                    ),
                                    label: const Text(
                                      'GET',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
