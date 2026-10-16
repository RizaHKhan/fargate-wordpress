<script setup>
useHead({
  meta: [{ name: 'viewport', content: 'width=device-width, initial-scale=1' }],
  link: [{ rel: 'icon', href: '/favicon.ico' }],
  htmlAttrs: {
    lang: 'en'
  }
})

const posts = ref([])
const error = ref(null)

const formatPostDate = date => new Intl.DateTimeFormat('en', {
  dateStyle: 'medium'
}).format(new Date(date))

const stripHtml = value => value?.replace(/<[^>]*>/g, '').trim() ?? ''

onMounted(async () => {
  try {
    const response = await fetch('http://localhost/wp-json/wp/v2/posts')

    if (!response.ok) {
      throw new Error(`Failed to load posts: ${response.status}`)
    }

    posts.value = await response.json()
  } catch (err) {
    error.value = err
  }
})
</script>

<template>
  <UApp>
    <main class="mx-auto max-w-3xl px-6 py-10">
      <header class="mb-8">
        <p class="text-sm font-semibold tracking-wide text-primary uppercase">
          Latest posts
        </p>
        <h1 class="mt-2 text-3xl font-bold text-gray-950 dark:text-white">
          WordPress Blog
        </h1>
      </header>

      <div
        v-if="error"
        class="rounded-lg border border-red-200 bg-red-50 p-4 text-red-700 dark:border-red-900 dark:bg-red-950 dark:text-red-200"
      >
        Failed to load posts.
      </div>

      <div
        v-else-if="!posts.length"
        class="rounded-lg border border-gray-200 p-6 text-gray-500 dark:border-gray-800 dark:text-gray-400"
      >
        No posts found.
      </div>

      <div
        v-else
        class="space-y-6"
      >
        <article
          v-for="post in posts"
          :key="post.id"
          class="rounded-xl border border-gray-200 bg-white p-6 shadow-sm transition hover:-translate-y-0.5 hover:shadow-md dark:border-gray-800 dark:bg-gray-900"
        >
          <time class="text-sm text-gray-500 dark:text-gray-400">
            {{ formatPostDate(post.date) }}
          </time>

          <h2 class="mt-2 text-2xl font-semibold text-gray-950 dark:text-white">
            {{ stripHtml(post.title.rendered) }}
          </h2>

          <p class="mt-3 leading-7 text-gray-700 dark:text-gray-300">
            {{ stripHtml(post.excerpt.rendered) }}
          </p>

          <a
            :href="post.link"
            class="mt-4 inline-flex items-center font-medium text-primary hover:underline"
            target="_blank"
            rel="noopener noreferrer"
          >
            Read post
          </a>
        </article>
      </div>
    </main>
  </UApp>
</template>
