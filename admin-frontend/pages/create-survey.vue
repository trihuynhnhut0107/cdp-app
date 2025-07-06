<template>
  <div class="max-w-4xl mx-auto p-6 h-screen flex flex-col">
    <!-- Navigation Header -->
    <div class="flex items-center justify-between mb-6">
      <h1 class="text-3xl font-bold">Create Survey</h1>
      <NuxtLink
        to="/"
        class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition-colors duration-200 flex items-center">
        <svg
          class="w-4 h-4 mr-2"
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M9 5H7a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"></path>
        </svg>
        View All Surveys
      </NuxtLink>
    </div>

    <div class="mb-6">
      <label class="block font-medium mb-2">Survey Name:</label>
      <input
        v-model="surveyName"
        placeholder="Enter survey name"
        class="w-full border border-gray-300 rounded px-4 py-2 focus:outline-none focus:ring focus:ring-blue-300" />
    </div>

    <div class="mb-6">
      <label class="block font-medium mb-2">Points Reward:</label>
      <input
        v-model.number="points"
        type="number"
        min="1"
        placeholder="Enter points to reward"
        class="w-full border border-gray-300 rounded px-4 py-2 focus:outline-none focus:ring focus:ring-blue-300" />
    </div>

    <!-- Scrollable questions container -->
    <div class="flex-1 overflow-y-auto mb-6 pr-2">
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
    </div>

    <!-- Fixed action buttons at bottom -->
    <div
      class="flex items-center gap-4 flex-wrap bg-white pt-4 border-t border-gray-200">
      <button
        @click="addQuestion"
        class="bg-green-500 text-white px-6 py-2 rounded hover:bg-green-600">
        Add Question
      </button>

      <button
        @click="generateDefaultQuestions"
        class="bg-purple-500 text-white px-6 py-2 rounded hover:bg-purple-600">
        Generate E-commerce Questions
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
const points = ref(1);
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

const generateDefaultQuestions = () => {
  questions.value = [
    {
      question_content:
        "How satisfied are you with your overall shopping experience?",
      question_type: "rating",
      options: [],
    },
    {
      question_content:
        "How would you rate the quality of the products you purchased?",
      question_type: "selection",
      options: [
        { option_content: "Excellent" },
        { option_content: "Very Good" },
        { option_content: "Good" },
        { option_content: "Fair" },
        { option_content: "Poor" },
      ],
    },
    {
      question_content: "How easy was it to find what you were looking for?",
      question_type: "selection",
      options: [
        { option_content: "Very Easy" },
        { option_content: "Easy" },
        { option_content: "Somewhat Easy" },
        { option_content: "Difficult" },
        { option_content: "Very Difficult" },
      ],
    },
    {
      question_content:
        "Which payment methods would you prefer to use? (Select all that apply)",
      question_type: "multiple",
      options: [
        { option_content: "Credit/Debit Card" },
        { option_content: "PayPal" },
        { option_content: "Digital Wallet (Apple Pay, Google Pay)" },
        { option_content: "Bank Transfer" },
        { option_content: "Cash on Delivery" },
        { option_content: "Buy Now, Pay Later (BNPL)" },
      ],
    },
    {
      question_content: "How would you rate our delivery/shipping service?",
      question_type: "selection",
      options: [
        { option_content: "Excellent" },
        { option_content: "Very Good" },
        { option_content: "Good" },
        { option_content: "Fair" },
        { option_content: "Poor" },
        { option_content: "Haven't used delivery service" },
      ],
    },
    {
      question_content: "What aspects of our website/app could be improved?",
      question_type: "multiple",
      options: [
        { option_content: "Loading Speed" },
        { option_content: "Search Functionality" },
        { option_content: "Product Images" },
        { option_content: "Product Descriptions" },
        { option_content: "Checkout Process" },
        { option_content: "Mobile Experience" },
        { option_content: "Customer Support" },
        { option_content: "Return/Refund Process" },
      ],
    },
    {
      question_content:
        "How likely are you to recommend our store to friends and family?",
      question_type: "rating",
      options: [],
    },
    {
      question_content:
        "What additional products or services would you like to see?",
      question_type: "open",
      options: [],
    },
    {
      question_content:
        "How do you primarily discover new products on our platform?",
      question_type: "selection",
      options: [
        { option_content: "Search Bar" },
        { option_content: "Browse Categories" },
        { option_content: "Recommendations" },
        { option_content: "Featured/Sale Items" },
        { option_content: "Social Media" },
        { option_content: "Email Newsletter" },
      ],
    },
    {
      question_content: "Please share any additional feedback or suggestions:",
      question_type: "open",
      options: [],
    },
  ];
};

const submitSurvey = async () => {
  // Validate points value
  if (!points.value || points.value < 1 || !Number.isInteger(points.value)) {
    alert("Points must be a positive integer (minimum 1)");
    return;
  }

  const surveyData = {
    survey_name: surveyName.value,
    questions: questions.value,
    point: points.value,
  };
  const res = await $fetch("http://localhost:8000/survey", {
    method: "POST",
    body: JSON.stringify(surveyData),
    onResponse({ response }) {
      if (response.status !== 201) {
        alert("Can't create survey");
      } else {
        surveyName.value = "";
        points.value = 1;
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
