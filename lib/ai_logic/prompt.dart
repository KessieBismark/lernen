// prompt_classes.dart

class VerbPrompt {
  final String data;

  VerbPrompt(this.data);

  String get prompt {
    return """
        Provide a comprehensive, structured json response for the verb "$data":
        {
            "german_data": "German translation of '$data' as well as the english if the verb is not in english",
            "data_forms": {
                "present": {
                    "ich": "form",
                    "du": "form",
                    "er/sie/es": "form",
                    "wir": "form",
                    "ihr": "form",
                    "sie/Sie": "form"
                },
                "present_continuous": {
                    "ich": "form",
                    "du": "form",
                    "er/sie/es": "form",
                    "wir": "form",
                    "ihr": "form",
                    "sie/Sie": "form"
                },
                "future": {
                    "ich": "form",
                    "du": "form",
                    "er/sie/es": "form",
                    "wir": "form",
                    "ihr": "form",
                    "sie/Sie": "form"
                },
                "past": {
                    "ich": "form",
                    "du": "form",
                    "er/sie/es": "form",
                    "wir": "form",
                    "ihr": "form",
                    "sie/Sie": "form"
                },
                "past_participle": "Past participle form"
            },
            "example_sentences": {
                "present": "Example sentence in present tense. (english translation)",
                "present_continuous": "Example sentence in present continuous. (english translation)",
                "future": "Example sentence in future tense. (english translation)",
                "past": "Example sentence in past tense. (english translation)",
                "past_participle": "Example sentence using past participle (english translation)",
                "Dative": "Example sentence using dative. (english translation)",
                "Accusative": "Example sentence using accusative. (english translation)"


            }
        }

        Ensure the response is valid, well-structured JSON and provides all verb forms and examples with pronouns.""";
  }
}

class ConversationPrompt {
  final String data;

  ConversationPrompt(this.data);

  String get prompt {
    return """
         Provide a bilingual conversation scenario based on the input provided. The response should include both the German and English translations for each line of dialogue and most have at least 30 conversations. Structure the response as a JSON object.

    Input: "$data"

    Output:
    {
        "conversation": [
            {
                "speaker 1": " 1",
                "german": "German translation of the first line of '$data'",
                "english": "English translation of the first line of '$data'"
            },
            {
                "speaker 2": "Interviewee",
                "german": "German translation of the second line of '$data'",
                "english": "English translation of the second line of '$data'"
            }
            // Add more speakers and lines if necessary
        ]
    }

    Ensure the output is valid, well-structured JSON and matches the conversation input provided.
    """;
  }
}

class ConversationContinuationPrompt {
  final String data;
  final String chatHistory;

  ConversationContinuationPrompt(this.data, this.chatHistory);

  String get prompt {
    return """
    Previous conversation:
    $chatHistory

    continue with this bilingual conversation based on the chat history input provided. The response should include both the German and English translations for each line of dialogue and most have at least 30 conversations. Structure the response as a JSON object.

    Input: "$data"

    Output:
    {
        "conversation": [
            {
                "speaker": "Interviewer",
                "german": "German translation of the first line of '$data'",
                "english": "English translation of the first line of '$data'"
            },
            {
                "speaker": "Interviewee",
                "german": "German translation of the second line of '$data'",
                "english": "English translation of the second line of '$data'"
            }
            // Add more speakers and lines if necessary
        ]
    }

    Ensure the output is valid, well-structured JSON and matches the conversation input provided.
    """;
  }
}

class GetTitlePrompt {
  final String query;

  GetTitlePrompt(this.query);

  String get prompt {
    return """
      "give me a short name for this $query not more than 2 words"

    Input: "$query"
    Output:
    {
       "chat_title":  
    }
    
    
    output result in a json format
        """;
  }
}

class GeneralSearchPrompt {
  final String query;
  final String chatHistory;

  GeneralSearchPrompt(this.query, this.chatHistory);

  String get prompt {
    return """
Previous conversation:
$chatHistory

You are a highly intelligent and knowledgeable assistant. Your goal is to provide accurate, concise, and relevant information in response to the user's query. Always maintain a professional and friendly tone. When applicable, include structured and detailed explanations, examples, or steps to help the user.

You are tasked with performing a general search based on the input provided. The response should be structured as an HTML document with the following sections:

Current query: $query


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Generate concise title for - $query</title>

</head>
<body>
    <section>
        <p>A concise, well-structured summary of the query, with examples or steps if needed.</p>
    </section>
    <!-- Include this section only if the query asks for a process or instructions -->
    <section>
        <h2>Step-by-Step Solution</h2>
        <ol>
            <li>Step 1: Provide a clear description of the first step.</li>
            <li>Step 2: Explain the next step in detail.</li>
            <li>Step 3: Continue adding steps as necessary.</li>
        </ol>
    </section>
    <!-- Include the following only if relevant -->
    <section>
        <h2>List</h2>
        <ul>
            <li>Item 1: Provide details here</li>
            <li>Item 2: Add more information</li>
            <li>Item 3: Continue the list as necessary</li>
        </ul>
    </section>
    <section>
        <h2>Code</h2>
        <pre><code>
// Provide a code snippet related to the query, with comments explaining its functionality.
        </code></pre>
    </section>
    <section>
        <h2>Table</h2>
        <table>
            <thead>
                <tr>
                    <th>Column 1</th>
                    <th>Column 2</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Row 1 Column 1</td>
                    <td>Row 1 Column 2</td>
                </tr>
                <tr>
                    <td>Row 2 Column 1</td>
                    <td>Row 2 Column 2</td>
                </tr>
            </tbody>
        </table>
    </section>
    <!-- End optional sections -->
</body>
</html>
    """;
  }
}

class GermanQuizPrompt {
  final String query;

  GermanQuizPrompt(this.query);

  String get prompt {
    return """
Generate 10 multiple-choice questions in German suitable for a $query learner.

### CORE PRINCIPLE:
Create questions where the correct answer is OBVIOUS and the wrong answers are CLEARLY DIFFERENT (not subtle variations). The wrong options should be from ENTIRELY DIFFERENT CATEGORIES, making the correct answer unmistakable.

### ABSOLUTE RULES - MUST FOLLOW:

1. **DISTINCT CATEGORY OPTIONS**: The 3 wrong answers must come from DIFFERENT functional categories
   - ❌ WRONG: Options all from "breakfast items" (Brötchen, Toast, Müsli, Cornflakes)
   - ✅ RIGHT: One correct (breakfast item) + options from: clothing, animals, tools, places

2. **NO AMBIGUITY**: Only ONE option can reasonably fit the sentence context
   - Test each option: If substituted, would a native speaker accept it? If yes → reject that option
   - Context must make the correct answer the ONLY sensible choice

3. **SEMANTIC DISTANCE**: Wrong answers should have minimal overlap with correct answer
   - ❌ WRONG: "Tee" vs "Kaffee" vs "Saft" (all beverages - confusingly similar)
   - ✅ RIGHT: "Kaffee" (beverage) vs "Stuhl" (furniture) vs "Hund" (animal) vs "Hammer" (tool)

4. **GRAMMATICAL CONSISTENCY**: All options must fit the grammatical structure
   - All nouns must have correct case/gender to maintain symmetry
   - Example: "Ich sehe einen _" → all options need accusative masculine singular

### FORMAT TEMPLATE:

Sentence: [Specific context] + [blank for category item]
Category: [Category name]
Options: [CORRECT answer + 3 items from DIFFERENT categories]
Correct: [The ONE that fits the specific context]
English: "[Full sentence translation]"
Explanation: "Category: [CATEGORY]. Correct answer is '[CORRECT]' because [REASON]. Other options are wrong because: (1) '[WRONG1]' is a [DIFFERENT CATEGORY] with no connection to the context, (2) '[WRONG2]' is a [DIFFERENT CATEGORY] unrelated to the sentence meaning, (3) '[WRONG3]' is a [DIFFERENT CATEGORY] that contradicts the context."

### EXAMPLES WITH EXPLANATIONS:

Example 1:
Question: "Um mein Auto zu öffnen, benutze ich meinen _."
Category: OBJECTS USED FOR SPECIFIC PURPOSE
Options: ["Schlüssel", "Löffel", "Regenschirm", "Buch"]
Correct: "Schlüssel"
English: "To open my car, I use my key."
Explanation: "Category: VEHICLE TOOLS. Correct answer is 'Schlüssel' because it's the standard tool for unlocking vehicles. Other options are wrong because: (1) 'Löffel' (spoon) is a kitchen utensil completely unrelated to vehicles, (2) 'Regenschirm' (umbrella) is weather equipment with no connection to car operation, (3) 'Buch' (book) is reading material with no functional relationship to opening a car."

Example 2:
Question: "Der Arzt untersucht meinen Patienten mit einem _."
Category: MEDICAL TOOLS
Options: ["Stethoskop", "Tennisschläger", "Kochplatte", "Kaugummi"]
Correct: "Stethoskop"
English: "The doctor examines my patient with a stethoscope."
Explanation: "Category: MEDICAL INSTRUMENTS. Correct answer is 'Stethoskop' because it's the primary diagnostic tool in medicine. Other options are wrong because: (1) 'Tennisschläger' (tennis racket) is a sports equipment completely unrelated to medical examination, (2) 'Kochplatte' (stove) is a cooking appliance with no medical function, (3) 'Kaugummi' (chewing gum) is a food item with no place in medical practice."

Example 3:
Question: "Zum Schreiben in der Schule benutze ich einen _."
Category: WRITING TOOLS
Options: ["Stift", "Schmetterling", "Pizza", "Fahrrad"]
Correct: "Stift"
English: "To write at school, I use a pen."
Explanation: "Category: SCHOOL SUPPLIES. Correct answer is 'Stift' (pen) because it's the primary tool for writing. Other options are wrong because: (1) 'Schmetterling' (butterfly) is an insect with no connection to writing or school, (2) 'Pizza' (pizza) is food unrelated to academic work, (3) 'Fahrrad' (bicycle) is a vehicle completely irrelevant to writing."

### CATEGORY MATRIX (Mix and Match):

CORRECT ANSWER CATEGORY → WRONG OPTION CATEGORIES (choose 3 different ones):

Kitchen Tools → Animals, Clothing, Weather, Sports Equipment
Food Items → Vehicles, Furniture, Tools, Emotions
Clothing → School Subjects, Music Instruments, Emotions, Vegetables
Transportation → Plants, Body Parts, Furniture, Sports
Weather Items → Professions, Numbers, Colors, Emotions
School Supplies → Animals, Foods, Vehicles, Buildings
Furniture → Emotions, Actions, Fruits, Professions

### STEP-BY-STEP GENERATION PROCESS:

1. Choose a specific, real-world context (action, location, situation)
2. Identify what object/word fits ONLY that context
3. Select 3 wrong answers from DIFFERENT, unrelated domains
4. Verify incorrect answers make NO sense when substituted
5. Write clear explanation for why each wrong option fails in context

### VALIDATION CHECKLIST:
✅ Does the correct answer fit the context PERFECTLY?
✅ Would a native speaker ONLY accept this answer?
✅ Are the 3 wrong answers from DIFFERENT categories?
✅ Would NO student pick a wrong answer by confusing it with correct?
✅ Does each wrong answer seem obviously irrelevant?

### JSON FORMAT:
{
    "questions": [
        {
            "question": "Am Morgen trinke ich immer eine Tasse _.",
            "category": "HEISSGETRÄNKE",
            "options": ["Kaffee", "Wasser", "Bier", "Saft"],
            "correct_answer": "Kaffee",
            "english_translation": "In the morning I always drink a cup of coffee.",
            "english_explanation": "Category: HOT DRINKS. Correct answer is 'Kaffee' because it's a typical morning hot beverage. Other options are wrong because: (1) 'Wasser' (water) is usually drunk cold, not as a morning ritual drink, (2) 'Bier' (beer) is alcoholic and not appropriate for morning, (3) 'Saft' (juice) is typically cold and often consumed at breakfast but not as a 'Tasse' (cup), which implies a hot drink."
        }
    ]
}

### GENERATE 10 QUESTIONS FOLLOWING THIS EXACT PATTERN:
1. Question with specific context
2. Category label
3. 4 options from DIFFERENT functional categories (NOT all from same category)
4. Only ONE fits the context
5. Explanation MUST list why each wrong option doesn't fit
6. Use ENTIRELY DIFFERENT categories for wrong answers to ensure obvious distinction

Return only valid JSON with 10 random questions with their explanations and correct answers. Do not return the examples given in the instructions, generate new ones using the examples as guide.
""";
  }
}

// Example usage:
void main() {
  // Create a verb prompt
  final verbPrompt = VerbPrompt('gehen');
  print('Verb Prompt: ${verbPrompt.prompt.substring(0, 100)}...\n');

  // Create a conversation prompt
  final conversationPrompt =
      ConversationPrompt('Ordering food at a restaurant');
  print(
      'Conversation Prompt: ${conversationPrompt.prompt.substring(0, 100)}...\n');

  // Create a conversation continuation prompt
  final continuationPrompt = ConversationContinuationPrompt(
      'Continue discussing the menu', 'Previous conversation about appetizers');
  print(
      'Continuation Prompt: ${continuationPrompt.prompt.substring(0, 100)}...\n');

  // Create a title prompt
  final titlePrompt = GetTitlePrompt('German verb conjugation practice');
  print('Title Prompt: ${titlePrompt.prompt.substring(0, 100)}...\n');

  // Create a general search prompt
  final searchPrompt = GeneralSearchPrompt('How to learn German grammar',
      'Previous discussion about German vocabulary');
  print('General Search Prompt: ${searchPrompt.prompt.substring(0, 100)}...\n');

  // Create a German quiz prompt
  final quizPrompt = GermanQuizPrompt('beginner');
  print('German Quiz Prompt: ${quizPrompt.prompt.substring(0, 100)}...\n');
}
