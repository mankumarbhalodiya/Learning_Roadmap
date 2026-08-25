import 'package:flutter/foundation.dart';

class SkillItem {
  final String title;
  final String category;
  final String description;
  final List<String> keyCompetencies;
  final String careerOutlook;
  final String averageSalary;
  final List<AssessmentQuestion> assessmentQuestions;

  SkillItem({
    required this.title,
    required this.category,
    required this.description,
    required this.keyCompetencies,
    required this.careerOutlook,
    required this.averageSalary,
    required this.assessmentQuestions,
  });
}

class SkillCategoryData {
  final String title;
  final List<SkillItem> skills;

  SkillCategoryData({
    required this.title,
    required this.skills,
  });
}

class AssessmentQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  AssessmentQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

class SkillRepository {
  static List<SkillCategoryData> get categories => [
        SkillCategoryData(
          title: 'Software & Web Development',
          skills: [
            _createSkill(
              'Python Developer',
              'Software & Web Development',
              'Master backend development, automation scripts, and API engineering with Python.',
              ['Python Syntax & Data Structures', 'Django / FastAPI', 'REST & GraphQL APIs', 'Database ORM (PostgreSQL/SQLAlchemy)'],
              'High Demand (+22% growth)',
              '\$115,000 / yr',
              [
                AssessmentQuestion(
                  question: 'What is the primary difference between a List and a Tuple in Python?',
                  options: ['Lists are immutable; Tuples are mutable', 'Lists are mutable; Tuples are immutable', 'Tuples can only store numbers', 'Lists cannot be indexed'],
                  correctIndex: 1,
                ),
                AssessmentQuestion(
                  question: 'Which framework is primarily used for asynchronous microservices in Python?',
                  options: ['Flask', 'FastAPI', 'Django', 'Bottle'],
                  correctIndex: 1,
                ),
                AssessmentQuestion(
                  question: 'What does the "GIL" stand for in Python?',
                  options: ['Global Interface Language', 'Global Interpreter Lock', 'General Integration Logic', 'Garbage Inspection Loop'],
                  correctIndex: 1,
                ),
              ],
            ),
            _createSkill('Java Developer', 'Software & Web Development', 'Build enterprise scale backend applications with Spring Boot and Java.', ['Core Java & OOP', 'Spring Boot Framework', 'Microservices', 'JVM Optimization'], 'Very High Demand', '\$118,000 / yr', []),
            _createSkill('C++ Developer', 'Software & Web Development', 'High-performance systems programming, game engines, and low-level optimization.', ['Memory Management & Pointers', 'STL & Templates', 'Concurrency & Threads', 'C++20 Standards'], 'Steady Demand', '\$122,000 / yr', []),
            _createSkill('JavaScript Developer', 'Software & Web Development', 'Build modern full-stack web applications with ES6+, Node.js, and TypeScript.', ['ES6+ Syntax & Async/Await', 'DOM & Event Loop', 'Node.js & Express', 'TypeScript Systems'], 'High Demand', '\$108,000 / yr', []),
            _createSkill('Frontend Developer', 'Software & Web Development', 'Craft responsive, intuitive user interfaces with modern web standards.', ['React / Vue / Svelte', 'CSS Grid & Modern Design Systems', 'Web Performance & Accessibility', 'State Management'], 'High Demand', '\$105,000 / yr', []),
            _createSkill('Backend Developer', 'Software & Web Development', 'Design scalable server-side systems, database architecture, and security.', ['RESTful & gRPC APIs', 'SQL & NoSQL Databases', 'Caching (Redis)', 'Distributed Systems'], 'Very High Demand', '\$120,000 / yr', []),
            _createSkill('Full Stack Developer', 'Software & Web Development', 'End-to-end web engineering from database schema design to responsive UI.', ['Frontend & Backend Synergy', 'API Integration', 'Authentication & JWT', 'CI/CD Pipelines'], 'Highest Demand', '\$125,000 / yr', []),
            _createSkill('Web Developer', 'Software & Web Development', 'Modern web standard development, SEO optimization, and responsive design.', ['HTML5 / CSS3 / JavaScript', 'CMS & Frameworks', 'Web Accessibility (WCAG)', 'Performance Tuning'], 'Moderate Demand', '\$92,000 / yr', []),
            _createSkill('PHP / Laravel Developer', 'Software & Web Development', 'Server-side web architecture using PHP 8 and the Laravel ecosystem.', ['Laravel Framework', 'Blade & Livewire', 'Database Migrations', 'MVC Pattern'], 'Steady Demand', '\$98,000 / yr', []),
            _createSkill('Software Engineer', 'Software & Web Development', 'Fundamental software principles, architecture patterns, and engineering lifecycle.', ['Data Structures & Algorithms', 'System Architecture', 'Design Patterns', 'Testing & Verification'], 'Very High Demand', '\$130,000 / yr', []),
          ],
        ),
        SkillCategoryData(
          title: 'AI & Data',
          skills: [
            _createSkill(
              'Data Analyst',
              'AI & Data',
              'Extract insights from data using SQL, Python, and business intelligence dashboards.',
              ['SQL Queries & Joins', 'Pandas & NumPy', 'Tableau / PowerBI', 'Statistical Analysis'],
              'High Demand (+25% growth)',
              '\$95,000 / yr',
              [
                AssessmentQuestion(
                  question: 'Which SQL clause is used to aggregate data based on grouped columns?',
                  options: ['ORDER BY', 'GROUP BY', 'HAVING BY', 'WHERE'],
                  correctIndex: 1,
                ),
                AssessmentQuestion(
                  question: 'Which Python library is primarily used for data manipulation and DataFrames?',
                  options: ['NumPy', 'Pandas', 'Matplotlib', 'Scipy'],
                  correctIndex: 1,
                ),
              ],
            ),
            _createSkill(
              'Data Scientist',
              'AI & Data',
              'Build predictive machine learning models and discover deep patterns in big data.',
              ['Statistical Modeling', 'Machine Learning (Scikit-Learn)', 'Feature Engineering', 'Data Visualization'],
              'Exponential Growth',
              '\$135,000 / yr',
              [
                AssessmentQuestion(
                  question: 'What is overfitting in Machine Learning?',
                  options: ['Model performs well on training data but poorly on test data', 'Model performs poorly on both training and test data', 'Model trains too quickly', 'Data has too few features'],
                  correctIndex: 0,
                ),
                AssessmentQuestion(
                  question: 'Which algorithm is commonly used for classification problems?',
                  options: ['Linear Regression', 'Logistic Regression', 'K-Means Clustering', 'PCA'],
                  correctIndex: 1,
                ),
              ],
            ),
            _createSkill('Machine Learning Engineer', 'AI & Data', 'Deploy scalable ML pipelines, neural networks, and MLOps workflows.', ['Deep Learning (PyTorch/TensorFlow)', 'Model Deployment', 'MLOps & Feature Stores', 'Model Optimization'], 'Exponential Growth', '\$145,000 / yr', []),
            _createSkill('AI Engineer', 'AI & Data', 'Build intelligent applications leveraging Large Language Models, RAG, and AI agents.', ['LLM Fine-tuning & RAG', 'LangChain / LlamaIndex', 'Vector Databases (Pinecone/Chroma)', 'Prompt Engineering'], 'Critical Emerging Role', '\$150,000 / yr', []),
            _createSkill('Data Engineer', 'AI & Data', 'Construct big data pipelines, data warehouses, and ETL streaming infrastructure.', ['Apache Spark & Airflow', 'Data Warehousing (Snowflake/BigQuery)', 'ETL Pipeline Design', 'Scala & Python'], 'Very High Demand', '\$138,000 / yr', []),
            _createSkill('Generative AI Engineer', 'AI & Data', 'Develop state-of-the-art GenAI models, diffusion models, and AI agent platforms.', ['Transformer Architectures', 'Multimodal Models', 'Fine-tuning & LoRA', 'AI Safety & Alignment'], 'Explosive Growth', '\$160,000 / yr', []),
          ],
        ),
        SkillCategoryData(
          title: 'Mobile & Cross-Platform',
          skills: [
            _createSkill(
              'Flutter Developer',
              'Mobile & Cross-Platform',
              'Build beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.',
              ['Dart Programming', 'Flutter Widget Architecture', 'State Management (Provider/Riverpod/Bloc)', 'Custom Animations & Paint'],
              'High Demand',
              '\$112,000 / yr',
              [
                AssessmentQuestion(
                  question: 'What is the main difference between StatelessWidget and StatefulWidget in Flutter?',
                  options: [
                    'StatelessWidget cannot draw UI',
                    'StatefulWidget maintains state that can change over time',
                    'StatelessWidget is only used for text',
                    'StatefulWidget cannot re-render'
                  ],
                  correctIndex: 1,
                ),
                AssessmentQuestion(
                  question: 'Which widget is best suited for building a scrollable list of item chips or cards?',
                  options: ['Column', 'ListView or Wrap', 'Container', 'Stack'],
                  correctIndex: 1,
                ),
              ],
            ),
            _createSkill('iOS Developer', 'Mobile & Cross-Platform', 'Craft native iOS experiences with Swift, SwiftUI, and iOS SDKs.', ['Swift & SwiftUI', 'Combine & Concurrency', 'Core Data / SwiftData', 'App Store Deployment'], 'High Demand', '\$120,000 / yr', []),
            _createSkill('Android Developer', 'Mobile & Cross-Platform', 'Develop modern native Android apps with Kotlin and Jetpack Compose.', ['Kotlin & Coroutines', 'Jetpack Compose', 'Room Database', 'Android Architecture Components'], 'High Demand', '\$118,000 / yr', []),
          ],
        ),
        SkillCategoryData(
          title: 'Cybersecurity & Cloud',
          skills: [
            _createSkill('DevOps Engineer', 'Cybersecurity & Cloud', 'Automate CI/CD pipelines, container orchestration, and infrastructure as code.', ['Docker & Kubernetes', 'Terraform / Ansible', 'CI/CD (GitHub Actions)', 'Cloud (AWS/GCP/Azure)'], 'Highest Demand', '\$135,000 / yr', []),
            _createSkill('Cloud Architect', 'Cybersecurity & Cloud', 'Design resilient, scalable cloud platform architectures.', ['AWS / GCP Architecture', 'Serverless Systems', 'Networking & VPC Security', 'Cost Optimization'], 'Very High Demand', '\$155,000 / yr', []),
            _createSkill('Cybersecurity Specialist', 'Cybersecurity & Cloud', 'Protect applications and cloud networks against vulnerabilities and attacks.', ['Penetration Testing', 'Network Security', 'Cryptography', 'Incident Response'], 'Critical Global Demand', '\$128,000 / yr', []),
            _createSkill('Systems Engineer', 'Cybersecurity & Cloud', 'Maintain high-availability system operations and operating system internals.', ['Linux Administration', 'Shell Scripting (Bash)', 'System Monitoring', 'Virtualization'], 'Steady Demand', '\$110,000 / yr', []),
          ],
        ),
        SkillCategoryData(
          title: 'Design & Product',
          skills: [
            _createSkill(
              'UI/UX Designer',
              'Design & Product',
              'Design beautiful, intuitive digital experiences, wireframes, and design systems.',
              ['Figma / Penpot', 'User Research & Persona Design', 'Wireframing & Prototyping', 'Design Systems & Tokens'],
              'High Demand',
              '\$102,000 / yr',
              [
                AssessmentQuestion(
                  question: 'What is the main objective of User Journey Mapping in UX Design?',
                  options: [
                    'To draw visual icons',
                    'To understand user actions, thoughts, and emotions across touchpoints',
                    'To choose color themes',
                    'To write backend logic'
                  ],
                  correctIndex: 1,
                ),
              ],
            ),
            _createSkill('Product Manager', 'Design & Product', 'Define product vision, roadmap strategy, user feedback loops, and sprint priorities.', ['Product Strategy', 'Agile & Scrum Methodologies', 'User Analytics', 'Feature Prioritization'], 'High Demand', '\$130,000 / yr', []),
            _createSkill('Technical Writer', 'Design & Product', 'Author comprehensive developer documentation, API guides, and architecture specs.', ['API Documentation', 'Markdown & Static Site Generators', 'Developer Experience (DX)', 'Technical Copywriting'], 'Steady Demand', '\$90,000 / yr', []),
          ],
        ),
      ];

  static SkillItem _createSkill(
    String title,
    String category,
    String description,
    List<String> keyCompetencies,
    String careerOutlook,
    String averageSalary,
    List<AssessmentQuestion> customQuestions,
  ) {
    // Provide default fallback assessment questions if custom list is empty
    final questions = customQuestions.isNotEmpty
        ? customQuestions
        : [
            AssessmentQuestion(
              question: 'What is the core prerequisite skill for mastering $title?',
              options: [
                'Basic understanding of fundamentals and logic',
                'Advanced 10 years experience',
                'Graphic design knowledge',
                'None required'
              ],
              correctIndex: 0,
            ),
            AssessmentQuestion(
              question: 'In professional workflows, how are updates managed in $title projects?',
              options: [
                'Version control systems like Git',
                'Copy pasting files manually',
                'Emailing ZIP archives',
                'No tracking needed'
              ],
              correctIndex: 0,
            ),
          ];

    return SkillItem(
      title: title,
      category: category,
      description: description,
      keyCompetencies: keyCompetencies,
      careerOutlook: careerOutlook,
      averageSalary: averageSalary,
      assessmentQuestions: questions,
    );
  }
}

class ActiveRoadmapManager {
  static final ValueNotifier<SkillItem?> activeSkillNotifier = ValueNotifier<SkillItem?>(
    // Default initial active skill to Flutter Developer so the user has an immediate roadmap progress view if wanted
    SkillRepository.categories[2].skills[0],
  );

  static void setActiveSkill(SkillItem skill) {
    activeSkillNotifier.value = skill;
  }
}
