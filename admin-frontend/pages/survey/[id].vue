<template>
  <div class="min-h-screen bg-gray-50 py-8">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <!-- Header -->
      <div class="mb-8">
        <div class="flex items-center justify-between">
          <div>
            <NuxtLink
              to="/surveys"
              class="text-blue-600 hover:text-blue-800 text-sm font-medium mb-2 inline-flex items-center">
              <svg
                class="w-4 h-4 mr-1"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M15 19l-7-7 7-7"></path>
              </svg>
              Back to Surveys
            </NuxtLink>
            <h1 class="text-3xl font-bold text-gray-900">
              {{ surveyData?.survey_name || "Survey Answers" }}
            </h1>
            <p class="mt-2 text-gray-600">View and analyze survey responses</p>
          </div>

          <div v-if="surveyData" class="text-right">
            <div class="text-2xl font-bold text-blue-600">
              {{ surveyData.total_responses }}
            </div>
            <div class="text-sm text-gray-600">Total Responses</div>
          </div>
        </div>
      </div>

      <!-- Loading State -->
      <div v-if="pending" class="flex justify-center items-center py-12">
        <div
          class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>

      <!-- Error State -->
      <div
        v-else-if="error"
        class="bg-red-50 border border-red-200 rounded-lg p-4">
        <div class="flex">
          <div class="flex-shrink-0">
            <svg
              class="h-5 w-5 text-red-400"
              viewBox="0 0 20 20"
              fill="currentColor">
              <path
                fill-rule="evenodd"
                d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z"
                clip-rule="evenodd" />
            </svg>
          </div>
          <div class="ml-3">
            <h3 class="text-sm font-medium text-red-800">
              Error loading survey answers
            </h3>
            <p class="mt-1 text-sm text-red-700">{{ error }}</p>
          </div>
        </div>
      </div>

      <!-- Survey Responses -->
      <div
        v-else-if="
          surveyData && surveyData.responses && surveyData.responses.length > 0
        "
        class="space-y-6">
        <div
          v-for="(response, index) in surveyData.responses"
          :key="response.user_id"
          class="bg-white rounded-lg shadow-md">
          <div class="p-6">
            <!-- User Info Header -->
            <div
              class="flex items-center justify-between mb-6 pb-4 border-b border-gray-200">
              <div class="flex items-center space-x-4">
                <div class="bg-blue-100 rounded-full p-3">
                  <svg
                    class="w-6 h-6 text-blue-600"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24">
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                  </svg>
                </div>
                <div>
                  <h3 class="text-lg font-semibold text-gray-900">
                    {{ response.user_name }}
                  </h3>
                  <p class="text-sm text-gray-600">{{ response.user_email }}</p>
                </div>
              </div>
              <div class="text-right">
                <div class="text-sm text-gray-500">
                  Response #{{ index + 1 }}
                </div>
                <div class="text-xs text-gray-400">
                  User ID: {{ response.user_id.slice(-8) }}
                </div>
              </div>
            </div>

            <!-- Answers -->
            <div class="space-y-4">
              <div
                v-for="answer in response.answers"
                :key="answer.question_id"
                class="border-l-4 border-blue-200 pl-4">
                <div class="mb-2">
                  <h4 class="font-medium text-gray-900">
                    {{ answer.question }}
                  </h4>
                  <span
                    class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-gray-100 text-gray-700 mt-1">
                    Question type:
                    {{
                      answer.question_type.charAt(0).toUpperCase() +
                      answer.question_type.slice(1)
                    }}
                  </span>
                </div>

                <div class="mt-2">
                  <!-- Rating Answer -->
                  <div
                    v-if="answer.question_type === 'rating'"
                    class="flex items-center space-x-1">
                    <span class="text-sm text-gray-600 mr-2">Rating:</span>
                    <div class="flex">
                      <svg
                        v-for="star in 5"
                        :key="star"
                        class="w-4 h-4"
                        :class="
                          star <= answer.answer
                            ? 'text-yellow-400'
                            : 'text-gray-300'
                        "
                        fill="currentColor"
                        viewBox="0 0 20 20">
                        <path
                          d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"></path>
                      </svg>
                    </div>
                    <span class="text-sm text-gray-600 ml-2"
                      >({{ answer.answer }}/5)</span
                    >
                  </div>

                  <!-- Multiple Choice/Selection Answer -->
                  <div
                    v-else-if="
                      answer.question_type === 'selection' ||
                      answer.question_type === 'multiple'
                    "
                    class="flex flex-wrap gap-2">
                    <span
                      v-for="option in answer.answer"
                      :key="option"
                      class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-blue-100 text-blue-800">
                      {{ option }}
                    </span>
                  </div>

                  <!-- Open Text Answer -->
                  <div
                    v-else-if="answer.question_type === 'open'"
                    class="bg-gray-50 rounded-lg p-3">
                    <p class="text-gray-700">{{ answer.answer }}</p>
                  </div>

                  <!-- Fallback for other types -->
                  <div v-else class="text-gray-700">
                    {{ answer.answer }}
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Empty State -->
      <div v-else class="text-center py-12">
        <svg
          class="mx-auto h-12 w-12 text-gray-400"
          fill="none"
          viewBox="0 0 24 24"
          stroke="currentColor">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M9 5H7a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"></path>
        </svg>
        <h3 class="mt-2 text-sm font-medium text-gray-900">No responses yet</h3>
        <p class="mt-1 text-sm text-gray-500">
          This survey hasn't received any responses yet.
        </p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
interface Answer {
  question_id: string;
  question: string;
  question_type: string;
  answer: any;
}

interface Response {
  user_id: string;
  user_name: string;
  user_email: string;
  answers: Answer[];
}

interface SurveyAnswersResponse {
  message: string;
  status: number;
  metadata: {
    survey_name: string;
    total_responses: number;
    responses: Response[];
  };
}

// Get survey ID from route
const route = useRoute();
const surveyId = route.params.id;

// Fetch survey answers
const {
  data: response,
  pending,
  error,
} = await useFetch<SurveyAnswersResponse>(
  `http://localhost:8000/answer/survey/${surveyId}`
);

// Extract survey data
const surveyData = computed(() => response.value?.metadata);

// Set page title
useHead({
  title: `${
    surveyData.value?.survey_name || "Survey"
  } Answers - Admin Dashboard`,
});
</script>

<style scoped></style>
