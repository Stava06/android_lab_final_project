import 'package:flutter/material.dart';
import '../services/auth_service.dart';

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
    // AuthGate will automatically return to LoginScreen.
  }

  void showProfileDialog() {
    final fullName = userData?['fullName'] ?? 'Unknown';
    final email = userData?['email'] ?? 'Unknown';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('User Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.account_circle, size: 70, color: Colors.blue),
              const SizedBox(height: 16),
              Text('Name: $fullName'),
              const SizedBox(height: 8),
              Text('Email: $email'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void openBooksDemo(String ageGroup, String fileType) {
    final List<String> books;

    if (ageGroup == '0-4') {
      books = ['Book 1', 'Book 2'];
    } else if (ageGroup == '4-8') {
      books = ['Book 3', 'Book 4'];
    } else {
      books = ['Book 5', 'Book 6'];
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
      onTap: () {
        openBooksDemo(ageGroup, fileType);
      },
      child: Card(
        color: color.withOpacity(0.12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 42, color: color),
              const SizedBox(height: 12),
              Text(
                'Ages $ageGroup',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                fileType.toUpperCase(),
                style: TextStyle(
                  fontSize: 16,
                  color: color,
                  fontWeight: FontWeight.w600,
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
      appBar: AppBar(
        title: const Text('Children Books App'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: showProfileDialog,
            icon: const Icon(Icons.person),
          ),
          IconButton(onPressed: logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: isLoadingUser
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName.isEmpty ? 'Welcome!' : 'Welcome, $fullName!',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Choose your child’s age and file type:',
                    style: TextStyle(fontSize: 17),
                  ),

                  const SizedBox(height: 24),

                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      children: [
                        buildAgeOption(
                          ageGroup: '0-4',
                          fileType: 'pdf',
                          icon: Icons.picture_as_pdf,
                          color: Colors.red,
                        ),
                        buildAgeOption(
                          ageGroup: '0-4',
                          fileType: 'word',
                          icon: Icons.description,
                          color: Colors.blue,
                        ),
                        buildAgeOption(
                          ageGroup: '4-8',
                          fileType: 'pdf',
                          icon: Icons.picture_as_pdf,
                          color: Colors.red,
                        ),
                        buildAgeOption(
                          ageGroup: '4-8',
                          fileType: 'word',
                          icon: Icons.description,
                          color: Colors.blue,
                        ),
                        buildAgeOption(
                          ageGroup: '8-12',
                          fileType: 'pdf',
                          icon: Icons.picture_as_pdf,
                          color: Colors.red,
                        ),
                        buildAgeOption(
                          ageGroup: '8-12',
                          fileType: 'word',
                          icon: Icons.description,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
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
  final Set<String> downloadedBooks = {};

  void showDemoMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void getBook(String book) {
    setState(() {
      downloadedBooks.add(book);
    });

    showDemoMessage(
      'Demo: In a full version, this would download $book as ${widget.fileType.toUpperCase()}.',
    );
  }

  void openBook(String book) {
    showDemoMessage('Demo: In a full version, this would open $book.');
  }

  void uploadBook() {
    showDemoMessage(
      'Demo: In a full version, this would upload a ${widget.fileType.toUpperCase()} file.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ages ${widget.ageGroup}'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Books for Ages ${widget.ageGroup} - ${widget.fileType.toUpperCase()}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            Expanded(
              child: ListView.builder(
                itemCount: widget.books.length,
                itemBuilder: (context, index) {
                  final book = widget.books[index];
                  final isDownloaded = downloadedBooks.contains(book);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 14),
                    child: ListTile(
                      leading: Icon(
                        widget.fileType == 'pdf'
                            ? Icons.picture_as_pdf
                            : Icons.description,
                        color: widget.fileType == 'pdf'
                            ? Colors.red
                            : Colors.blue,
                      ),
                      title: Text(book),
                      subtitle: Text(widget.fileType.toUpperCase()),
                      trailing: ElevatedButton(
                        onPressed: () {
                          if (isDownloaded) {
                            openBook(book);
                          } else {
                            getBook(book);
                          }
                        },
                        child: Text(isDownloaded ? 'OPEN' : 'GET'),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: uploadBook,
                icon: const Icon(Icons.upload_file),
                label: const Text('Upload Book'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
