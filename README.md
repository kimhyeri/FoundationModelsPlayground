# FoundationModelsPlayground
A collection of on-device examples using Apple’s FoundationModels framework

---

## 🧪 Available Demos

### 1. 💬 On-device Chatbot  
A conversational chatbot that responds in a friendly tone.  
> ✅ Powered by `SystemLanguageModel`  
> ✅ Maintains short context history  
> ✅ Runs 100% locally on-device  

[🗂️ ChatBot](./ChatBot/)  
![ChatBot Demo](./Demos/chatBot.gif)

### 2. 📝 Grammar Correction  
An English tutor that checks your sentence, explains grammar mistakes, and provides corrections.  
> ✅ Powered by `SystemLanguageModel`  
> ✅ Offers detailed explanations  
> ✅ Runs 100% locally on-device  

[🗂️ GrammarCorrection](./GrammarCorrection/)  
![GrammarCorrection Demo](./Demos/grammarCorrection.gif)

### 3. 🍳 Recipe Generator  
Creates cooking recipes with clear step-by-step instructions.
> ✅ Powered by `SystemLanguageModel`  
> ✅ Supports streaming output for recipe generation  
> ✅ Produces structured results (title, ingredients, steps)  
> ✅ Runs 100% locally on-device  

[🗂️ RecipeGenerator](./RecipeGenerator/)  
![RecipeGenerator Demo](./Demos/recipeGenerator.gif)

### 4. 🏋️‍♀️ AI Workout Plan Generator
Generates personalized workout routines tailored to your goals, equipment, and experience level.
> ✅ Powered by FoundationModels (on-device)  
> ✅ Fully customizable inputs (goal, duration, equipment, level)  
> ✅ Produces clear step-by-step exercise lists  
> ✅ Runs 100% locally—no network required  

[🗂️ WorkoutGuide](./WorkoutGuide/)  
![WorkoutGuide Demo](./Demos/workoutGuide.gif)

### 5. 🌙 CozyTales — Calm Storytelling for Children
An on-device storytelling app that generates calming, child-friendly stories in real time—designed to help children relax in stressful situations such as flights, bedtime, or unfamiliar environments.
> ✅ Powered by `SystemLanguageModel`  
> ✅ Generates safe, soothing stories entirely on-device  
> ✅ Adjustable story length (1–12 minutes)  
> ✅ Real-time text-to-speech playback using `AVSpeechSynthesizer`  

[🗂️ CozyTales](./CozyTales/)  
![CozyTales Demo](./Demos/cozyTales.gif)

### 6. 🌤️ Weather Outfit Advisor
An on-device assistant that checks the weather for a city and suggests what to wear based on the conditions.
> ✅ Powered by `SystemLanguageModel`  
> ✅ Uses a custom `Tool` (`get_weather`) for weather lookup  
> ✅ Streams outfit advice in real time  
> ✅ Displays structured weather info (temperature, humidity, wind, condition)  
> ✅ Runs 100% locally on-device  

[🗂️ WeatherOutfitAdvisor](./WeatherOutfitAdvisor/)  
![WeatherOutfitAdvisor Demo](./Demos/weatherOutfitAdvisor.gif)

---

## 💡 About FoundationModels

[FoundationModels](https://developer.apple.com/documentation/foundationmodels) is Apple’s official framework for running foundation language models on-device.  
These examples help developers explore capabilities like text generation, summarization, and natural dialogue — all without relying on cloud inference.

---
