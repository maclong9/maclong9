import adapter from '@sveltejs/adapter-static';
import { Config } from '@sveltejs/kit';
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';
import { escapeSvelte, mdsvex } from 'mdsvex';
import rehypeCallouts from 'rehype-callouts';
import rehypeSlug from 'rehype-slug';
import remarkToc from 'remark-toc';
import { bundledLanguages, getSingletonHighlighter } from 'shiki';

const config: Config = {
	extensions: ['.svelte'],
	preprocess: [
		vitePreprocess(),
		mdsvex({
			extensions: ['.md'],
			highlight: {
				highlighter: async (code, lang = 'text') => {
					const highlighter = await getSingletonHighlighter({
						themes: ['vitesse-dark'],
						langs: Object.keys(bundledLanguages)
					});
					const html = escapeSvelte(highlighter.codeToHtml(code, { lang, theme: 'vitesse-dark' }));
					return `{@html \`${html}\` }`;
				}
			},
			remarkPlugins: [[remarkToc, { tight: true }]],
			rehypePlugins: [rehypeSlug, rehypeCallouts]
		})
	],
	kit: {
		adapter: adapter()
	}
};

export default config;
