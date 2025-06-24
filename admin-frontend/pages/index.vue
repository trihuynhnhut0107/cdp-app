<template>
  <div class="max-w-4xl mx-auto p-6">
    <h1 class="text-3xl font-bold mb-6">Create Survey</h1>

    <div class="mb-6">
      <label class="block font-medium mb-2">Survey Name:</label>
      <input
        v-model="surveyName"
        placeholder="Enter survey name"
        class="w-full border border-gray-300 rounded px-4 py-2 focus:outline-none focus:ring focus:ring-blue-300" />
    </div>

    <div
      v-for="(question, index) in questions"
      :key="index"
      class="border border-gray-300 rounded p-4 mb-6">
      <div class="flex justify-between items-start">
        <h2 class="text-lg font-semibold">Question {{ index + 1 }}</h2>
        <button
          @click="removeQuestion(index)"
          class="text-red-500 hover:underline">
          Remove
        </button>
      </div>

      <div class="mt-4">
        <label class="block font-medium mb-1">Question Content:</label>
        <input
          v-model="question.question_content"
          placeholder="Enter question content"
          class="w-full border border-gray-300 rounded px-4 py-2 focus:outline-none focus:ring focus:ring-blue-300" />
      </div>

      <div class="mt-4">
        <label class="block font-medium mb-1">Question Type:</label>
        <select
          v-model="question.question_type"
          class="w-full border border-gray-300 rounded px-4 py-2 focus:outline-none focus:ring focus:ring-blue-300">
          <option value="selection">Selection</option>
          <option value="multiple">Multiple</option>
          <option value="open">Open</option>
          <option value="rating">Rating</option>
        </select>
      </div>

      <div
        v-if="
          question.question_type === 'selection' ||
          question.question_type === 'multiple'
        "
        class="mt-4">
        <h4 class="font-semibold mb-2">Options</h4>
        <div
          v-for="(option, optIndex) in question.options"
          :key="optIndex"
          class="flex items-center gap-2 mb-2">
          <input
            v-model="option.option_content"
            placeholder="Enter option content"
            class="flex-1 border border-gray-300 rounded px-4 py-2 focus:outline-none focus:ring focus:ring-blue-300" />
          <button
            @click="removeOption(index, optIndex)"
            class="text-red-500 hover:underline">
            Remove
          </button>
        </div>
        <div class="flex items-center gap-4 mt-2">
          <button
            @click="addOption(index)"
            class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">
            Add Option
          </button>
          <p v-if="question.options.length < 2" class="text-red-500 text-sm">
            At least 2 options are required.
          </p>
        </div>
      </div>
    </div>

    <div class="flex items-center gap-4">
      <button
        @click="addQuestion"
        class="bg-green-500 text-white px-6 py-2 rounded hover:bg-green-600">
        Add Question
      </button>

      <button
        @click="submitSurvey"
        class="bg-blue-600 text-white px-6 py-2 rounded hover:bg-blue-700">
        Submit Survey
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref } from "vue";

const surveyName = ref("");
const questions = ref([
  {
    question_content: "",
    question_type: "selection",
    options: [{ option_content: "" }, { option_content: "" }],
  },
]);

const addQuestion = () => {
  questions.value.push({
    question_content: "",
    question_type: "selection",
    options: [{ option_content: "" }, { option_content: "" }],
  });
};

const removeQuestion = (index) => {
  questions.value.splice(index, 1);
};

const addOption = (questionIndex) => {
  questions.value[questionIndex].options.push({ option_content: "" });
};

const removeOption = (questionIndex, optionIndex) => {
  questions.value[questionIndex].options.splice(optionIndex, 1);
};

const submitSurvey = async () => {
  const surveyData = {
    survey_name: surveyName.value,
    questions: questions.value,
  };
  const res = await $fetch("http://localhost:8000/survey", {
    method: "POST",
    body: JSON.stringify(surveyData),
    onResponse({ response }) {
      if (response.status !== 201) {
        alert("Can't create survey");
      } else {
        surveyName.value = "";
        questions.value = [
          {
            question_content: "",
            question_type: "selection",
            options: [{ option_content: "" }, { option_content: "" }],
          },
        ];
      }
    },
  });
};
</script>
